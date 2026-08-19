import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'card.dart';
import 'ending.dart';
import 'heir.dart';
import 'legacy.dart';
import 'playtest.dart';
import 'score.dart';

/// Which side of the card a swipe committed to.
enum SwipeDirection { left, right }

/// Session-scoped game state. Nothing here persists.
///
/// Deliberately a plain [ChangeNotifier] — no framework, no injection. The
/// whole game is four integers, a current card, and a run counter.
class GameState extends ChangeNotifier {
  GameState({
    required List<GameCard> deck,
    required EndingSet endings,
    Legacy legacy = Legacy.empty,
    LegacyStore? store,
    ScoreStore? scores,
    int bestYear = 0,
    Random? random,
    RunTrace? trace,
  }) : assert(deck.isNotEmpty, 'GameState needs at least one card'),
       _scores = scores ?? InMemoryScoreStore(),
       // ignore: prefer_initializing_formals
       _bestYear = bestYear,
       // ignore: prefer_initializing_formals
       _trace = trace,
       _deck = deck,
       // ignore: prefer_initializing_formals
       _endings = endings,
       _store = store ?? InMemoryLegacyStore(),
       _legacy = legacy,
       _inheritedFlags = legacy.flags,
       _random = random ?? Random() {
    _current = _select();
  }

  final List<GameCard> _deck;
  final EndingSet _endings;
  final LegacyStore _store;
  final ScoreStore _scores;
  final Random _random;

  /// Playtest recorder, or null. See lib/playtest.dart: this is one null
  /// check per swipe when the session hooks are off, which is always in a
  /// shipped build.
  final RunTrace? _trace;

  Legacy _legacy;

  /// What this run inherited. Replaced wholesale on each death.
  Legacy get legacy => _legacy;

  static const int minMeter = 0;
  static const int maxMeter = 100;
  static const int startingMeter = 50;

  /// Blood is a counter, not a meter.
  ///
  /// It starts full, only ever decreases, cannot kill the player, is absent
  /// from the meter row, and gates nothing. Its only future consumer is
  /// succession. Nothing in this class may read it back into play.
  static const int bloodMax = 100;

  /// How many recently played cards to avoid repeating. Soft: if honouring
  /// it would leave nothing to draw, it is dropped rather than enforced.
  ///
  /// Note this caps weighting. A card cannot come up more than once every
  /// `recentWindow + 1` draws however heavy it is, and in a deck close to
  /// the window size recency, not weight, decides most draws. That is fine
  /// at 15 cards and intended at 150; it is worth remembering before
  /// concluding that a weight is being ignored.
  static const int recentWindow = 4;

  /// Flags set *this run*. Session-scoped and cleared by [restart].
  ///
  /// Kept separate from [_inheritedFlags] on purpose: the next legacy is
  /// derived from this set alone, which is what stops the father's
  /// inheritance being passed on again as if the son had earned it.
  final Set<String> _activeFlags = <String>{};

  /// Flags seeded from [legacy] at the start of the run. Never written to by
  /// a card, and never fed back into a new legacy.
  Set<String> _inheritedFlags;

  /// Ids of `once` cards already played this run.
  final Set<String> _playedOnce = <String>{};

  /// Ids of the last [recentWindow] cards played.
  final Queue<String> _recent = Queue<String>();

  // -------------------------------------------------------------------
  // Chain delivery.
  //
  // A follow-up at draw weight 45 competing against 364 eligible cards had
  // about a 1% chance of being reached by the third beat of a six-beat chain,
  // so the most effortful writing in the deck was effectively unreachable.
  // Weight is the wrong instrument: it expresses *more likely*, and an opener
  // is a promise, which needs *next*.
  //
  // So a resolved beat pins its successor, and the successor is delivered after
  // a short gap of ordinary cards. Three rules keep it from eating the deck:
  //
  //   * one chain in flight — while a beat is pending, no other chain's opener
  //     is eligible, which is why this is a single pending id and not a queue;
  //   * a gap of [minChainGap]..[maxChainGap] ordinary cards between beats,
  //     drawn per beat so it is not metronomic and cannot be learned;
  //   * eligibility is re-checked at delivery, and a beat that has become
  //     contradicted is dropped rather than deferred.
  // -------------------------------------------------------------------

  /// Ordinary cards between one beat and the next, inclusive bounds. Randomised
  /// per beat: a fixed gap teaches the player that every third card is the
  /// story.
  static const int minChainGap = 2;
  static const int maxChainGap = 3;

  /// If no chain has opened by this many swipes, the next draw is taken from
  /// the opener pool. One guaranteed chain per run.
  ///
  /// Without this the queue fixes completion but not reach: a given opener is
  /// only about 12% likely to be drawn in a 35-swipe run, so most runs would
  /// still contain no chain at all.
  static const int forcedOpenerAfter = 5;

  /// The beat waiting to be delivered, or null when no chain is in flight.
  GameCard? _pendingBeat;

  /// Ordinary cards still to be dealt before [_pendingBeat] is delivered.
  int _chainGap = 0;

  /// Chains whose opener has resolved this run. Only the count matters, and
  /// only for [forcedOpenerAfter].
  int _chainsOpened = 0;

  /// Swipes committed this run. Session-scoped, reset by [restart].
  int _swipes = 0;

  /// Beats dropped because they were contradicted by the time they came up.
  ///
  /// A chain dying silently is the failure that took four batches to notice
  /// last time, so it is counted rather than swallowed.
  int _beatsDropped = 0;

  int get chainsOpened => _chainsOpened;
  int get beatsDropped => _beatsDropped;

  /// The year of the reign the player is currently in. One card is one year.
  ///
  /// The seat is taken in year 1, before any card has been answered, so this
  /// is one ahead of [_swipes] rather than equal to it.
  ///
  /// **No calendar date is ever shown**, here or anywhere. docs/cast.md is
  /// explicit that no card states a year, because cards are drawn at random
  /// and there is no chronology to be consistent with. A count of years *in
  /// the seat* carries the same weight without inventing a timeline the deck
  /// would contradict.
  int get year => _swipes + 1;

  int _bestYear;

  /// The furthest any reign has ever got, in years. Survives the app closing.
  ///
  /// Belongs to the player rather than to a character: unlike [legacy] it is
  /// never seeded into a run, no card can read it, and it only ever climbs.
  int get bestYear => _bestYear;

  /// True while a chain is mid-delivery. Nothing in the UI reads this; it is
  /// here for the simulation harness and the tests.
  bool get chainInFlight => _pendingBeat != null;

  /// Every beat of every chain, keyed by "chainId/beat".
  late final Map<String, GameCard> _beats = <String, GameCard>{
    for (final GameCard card in _deck)
      if (card.chain != null) '${card.chain!.id}/${card.chain!.beat}': card,
  };

  GameCard? _successorOf(GameCard card) {
    final CardChain? chain = card.chain;
    if (chain == null) return null;
    return _beats['${chain.id}/${chain.beat + 1}'];
  }

  Set<String> get activeFlags => Set<String>.unmodifiable(_activeFlags);

  Set<String> get inheritedFlags => Set<String>.unmodifiable(_inheritedFlags);

  /// A flag counts as active whether this run set it or the father left it.
  bool _flagActive(String flag) =>
      _activeFlags.contains(flag) || _inheritedFlags.contains(flag);

  int _family = startingMeter;
  int _commission = startingMeter;
  int _cops = startingMeter;
  int _cash = startingMeter;

  int _blood = bloodMax;

  int get family => _family;
  int get commission => _commission;
  int get cops => _cops;
  int get cash => _cash;

  /// Full at the start of a run, monotonically non-increasing thereafter.
  int get blood => _blood;

  late GameCard _current;
  GameCard get current => _current;

  Ending? _ending;

  /// Null while the run is live; set once a meter has hit a bound.
  Ending? get ending => _ending;

  bool get isOver => _ending != null;

  Heir? _heir;

  /// Set alongside [ending]: who takes over, decided by the blood left when
  /// the father died. Null while a run is live.
  Heir? get heir => _heir;

  int _runCount = 1;

  /// 1 for the first run of the session, incremented on each [restart].
  /// Session-scoped only: nothing survives the app closing.
  int get runCount => _runCount;

  /// Applies the chosen side's effects, then either ends the run or draws
  /// the next card.
  void choose(SwipeDirection direction) {
    // A swipe that lands after the run is over changes nothing.
    if (isOver) return;

    final CardChoice choice = direction == SwipeDirection.left
        ? _current.left
        : _current.right;

    _family = _clamp(_family + choice.effects.family);
    _commission = _clamp(_commission + choice.effects.commission);
    _cops = _clamp(_cops + choice.effects.cops);
    _cash = _clamp(_cash + choice.effects.cash);

    // Blood is a cost, never a gain: the validator rejects negative values,
    // and the clamp floor means a drained counter simply stays at zero. It
    // is deliberately not fed into _findEnding.
    _blood = (_blood - choice.effects.blood).clamp(0, bloodMax);

    // Flags land before the next draw, so a card can gate on the choice
    // that was just made.
    _activeFlags.addAll(choice.setFlags);
    if (_current.once) _playedOnce.add(_current.id);
    _remember(_current.id);
    _swipes++;

    // Recorded before _advanceChain, so the entry describes the card the
    // player was actually looking at rather than the one queued behind it.
    _trace?.record(
      TraceEntry(
        swipe: _swipes,
        cardId: _current.id,
        speaker: _current.speaker,
        direction: direction == SwipeDirection.left ? 'left' : 'right',
        label: choice.label,
        chainId: _current.chain?.id,
        beat: _current.chain?.beat,
        vice: _current.vice,
        effects: <String, int>{
          'family': choice.effects.family,
          'commission': choice.effects.commission,
          'cops': choice.effects.cops,
          'cash': choice.effects.cash,
          'blood': choice.effects.blood,
        },
        setFlags: choice.setFlags.toList(),
        family: _family,
        commission: _commission,
        cops: _cops,
        cash: _cash,
        blood: _blood,
      ),
      _current,
    );

    _advanceChain();

    final Ending? ending = _findEnding();
    if (ending != null) {
      // The card that killed you stays on screen behind the ending.
      _ending = ending;
      // Read blood exactly once, at death. This is its only consumer.
      _heir = Inheritance.forBlood(_blood);
      // The record is settled here rather than in restart(), so a player who
      // dies and closes the app still keeps the reign they just managed.
      if (year > _bestYear) {
        _bestYear = year;
        // Fire and forget, as with the legacy: a failed write must not stall
        // the tap that starts the next run.
        unawaited(_scores.saveBestYear(_bestYear));
      }
      _trace?.endRun(ending: ending, heir: _heir, blood: _blood);
      notifyListeners();
      return;
    }

    _current = _select();
    notifyListeners();
  }

  /// Hands the game to the heir.
  ///
  /// The father's enemies and debts are derived from the flags *he* set,
  /// persisted, and seeded into the son's run. Everything else — meters,
  /// blood, played cards, ordinary flags — dies with him. Meters open at the
  /// heir's starting values rather than the neutral 50.
  void restart() {
    // Derived from this run's own flags only: the son inherits from his
    // father, never from his grandfather.
    final Legacy next = Legacy.fromRunFlags(_activeFlags);
    _legacy = next;
    _inheritedFlags = next.flags;
    // Fire and forget: a failed write must not stall the tap that started
    // the next run. PrefsLegacyStore swallows and logs its own errors.
    unawaited(_store.save(next));

    final Heir? heir = _heir;
    _family = heir?.family ?? startingMeter;
    _commission = heir?.commission ?? startingMeter;
    _cops = heir?.cops ?? startingMeter;
    _cash = heir?.cash ?? startingMeter;

    _blood = bloodMax;
    _ending = null;
    _heir = null;
    _activeFlags.clear();
    _playedOnce.clear();
    _recent.clear();
    // Chain state is run-scoped like everything else here. A beat surviving
    // into the heir's run would be a card about the father's dead nephew,
    // delivered to his son.
    _pendingBeat = null;
    _chainGap = 0;
    _chainsOpened = 0;
    _swipes = 0;
    _beatsDropped = 0;
    _runCount++;
    _trace?.startRun(_runCount);
    _current = _select();
    notifyListeners();
  }

  /// Meters are checked in [MeterKind] declaration order, so a swipe that
  /// pushes two meters to a bound at once resolves deterministically.
  Ending? _findEnding() {
    for (final MeterKind meter in MeterKind.values) {
      final int value = switch (meter) {
        MeterKind.family => _family,
        MeterKind.commission => _commission,
        MeterKind.cops => _cops,
        MeterKind.cash => _cash,
      };
      if (value <= minMeter) return _endings.lookup(meter, MeterBound.empty);
      if (value >= maxMeter) return _endings.lookup(meter, MeterBound.full);
    }
    return null;
  }

  int _clamp(int value) => value.clamp(minMeter, maxMeter);

  /// Called once per committed swipe, after the chosen side's flags have landed.
  ///
  /// The card just resolved is either a beat — in which case it pins its
  /// successor and opens the gap — or an ordinary card, which closes the gap by
  /// one. Both cases are handled here so the gap counts *cards the player saw*
  /// rather than draws attempted.
  void _advanceChain() {
    final CardChain? chain = _current.chain;
    if (chain != null) {
      if (chain.isOpener) _chainsOpened++;
      final GameCard? next = _successorOf(_current);
      if (next == null) {
        // Chain finished. Openers become eligible again.
        _pendingBeat = null;
        _chainGap = 0;
        return;
      }
      _pendingBeat = next;
      _chainGap = minChainGap + _random.nextInt(maxChainGap - minChainGap + 1);
      return;
    }
    if (_pendingBeat != null && _chainGap > 0) _chainGap--;
  }

  void _remember(String id) {
    _recent.addLast(id);
    while (_recent.length > recentWindow) {
      _recent.removeFirst();
    }
  }

  /// Picks the next card.
  ///
  /// Constraints are relaxed in order rather than enforced absolutely, so
  /// selection always returns something:
  ///   1. eligible and not recently seen
  ///   2. eligible, repeats allowed
  ///   3. filler and not recently seen
  ///   4. filler, repeats allowed
  ///   5. anything at all
  ///
  /// The deck validator guarantees at least one filler card exists, so in
  /// practice step 5 is unreachable; it is here so a malformed deck loaded
  /// in release degrades instead of throwing.
  GameCard _select() {
    // 0a. A beat whose gap has run out pre-empts the pool entirely.
    //
    // Eligibility is re-checked *here* rather than trusted from when the beat
    // was pinned: requires.flags cannot stop being satisfied (nothing clears a
    // flag) but excludesFlags can newly become true, and a beat that has been
    // contradicted in the meantime is dropped rather than deferred. Deferring
    // fires it later, when it is more wrong.
    final GameCard? pending = _pendingBeat;
    if (pending != null && _chainGap <= 0) {
      _pendingBeat = null;
      if (_isEligible(pending)) return pending;
      _beatsDropped++;
    }

    // 0b. One guaranteed chain per run.
    if (_pendingBeat == null &&
        _chainsOpened == 0 &&
        _swipes >= forcedOpenerAfter) {
      final List<GameCard> openers = _deck
          .where((GameCard c) => (c.chain?.isOpener ?? false) && _isEligible(c))
          .toList();
      final List<GameCard> fresh = _withoutRecent(openers);
      if (fresh.isNotEmpty) return _weightedPick(fresh);
      if (openers.isNotEmpty) return _weightedPick(openers);
    }

    final List<GameCard> eligible = _deck.where(_isDrawable).toList();
    final List<GameCard> freshEligible = _withoutRecent(eligible);
    if (freshEligible.isNotEmpty) return _weightedPick(freshEligible);
    if (eligible.isNotEmpty) return _weightedPick(eligible);

    final List<GameCard> filler = _deck.where(_isFiller).toList();
    final List<GameCard> freshFiller = _withoutRecent(filler);
    if (freshFiller.isNotEmpty) return _weightedPick(freshFiller);
    if (filler.isNotEmpty) return _weightedPick(filler);

    return _deck[_random.nextInt(_deck.length)];
  }

  /// A card is eligible when every required flag is active, no excluded flag
  /// is active, and it is not a spent `once` card.
  bool _isEligible(GameCard card) {
    if (card.once && _playedOnce.contains(card.id)) return false;
    for (final String flag in card.requires.flags) {
      if (!_flagActive(flag)) return false;
    }
    for (final String flag in card.requires.excludesFlags) {
      if (_flagActive(flag)) return false;
    }
    return true;
  }

  /// Eligible *and* allowed into the ordinary weighted pool.
  ///
  /// Two chain rules sit here rather than in [_isEligible], because the pending
  /// beat has to stay eligible for its own delivery check while being kept out
  /// of the pool:
  ///
  ///   * **A follow-up only ever arrives through the queue.** It was already
  ///     unreachable before its predecessor — its gate flag has one setter —
  ///     so this loses no content; it stops a beat arriving out of pace, and it
  ///     stops the pool spending a `once` beat the queue is holding.
  ///   * **While a chain is in flight, no other chain's opener is eligible.**
  ///     This is the concurrency cap. A 35-swipe run draws about 5.6 openers,
  ///     and letting them all queue would make every third card a chain beat
  ///     and starve the flag-free backbone.
  bool _isDrawable(GameCard card) {
    final CardChain? chain = card.chain;
    if (chain != null) {
      if (!chain.isOpener) return false;
      if (_pendingBeat != null) return false;
    }
    return _isEligible(card);
  }

  /// Unconditional and repeatable: cards that can never be filtered out.
  bool _isFiller(GameCard card) =>
      !card.once &&
      card.requires.flags.isEmpty &&
      card.requires.excludesFlags.isEmpty;

  List<GameCard> _withoutRecent(List<GameCard> pool) => pool
      .where((GameCard card) => !_recent.contains(card.id))
      .toList(growable: false);

  /// Weights are validated positive, so the total is always > 0 here.
  GameCard _weightedPick(List<GameCard> pool) {
    final int total = pool.fold<int>(
      0,
      (int sum, GameCard card) => sum + card.weight,
    );
    int roll = _random.nextInt(total);
    for (final GameCard card in pool) {
      roll -= card.weight;
      if (roll < 0) return card;
    }
    return pool.last;
  }
}
