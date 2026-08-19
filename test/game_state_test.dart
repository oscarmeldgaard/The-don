// Pure game-logic checks:  flutter test

import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';
import 'package:mafia_reigns/flags.dart';
import 'package:mafia_reigns/game_state.dart';
import 'package:mafia_reigns/heir.dart';
import 'package:mafia_reigns/legacy.dart';

/// The real ending copy, so these tests exercise what ships.
final EndingSet _endings = EndingsRepository.parse(
  File('assets/cards/endings.json').readAsStringSync(),
  throwOnInvalid: true,
);

CardEffects _effects({
  int family = 0,
  int commission = 0,
  int cops = 0,
  int cash = 0,
  int blood = 0,
}) =>
    CardEffects(
      family: family,
      commission: commission,
      cops: cops,
      cash: cash,
      blood: blood,
    );

GameCard _card(
  String id, {
  CardEffects? left,
  CardEffects? right,
  List<String> setsLeft = const <String>[],
  List<String> setsRight = const <String>[],
  List<String> requiresFlags = const <String>[],
  List<String> excludesFlags = const <String>[],
  int weight = 1,
  bool once = false,
  CardChain? chain,
}) =>
    GameCard(
      chain: chain,
      id: id,
      speaker: 'SPEAKER $id',
      text: 'text $id',
      left: CardChoice(
        label: 'LEFT',
        effects: left ?? _effects(),
        setFlags: setsLeft,
      ),
      right: CardChoice(
        label: 'RIGHT',
        effects: right ?? _effects(),
        setFlags: setsRight,
      ),
      requires: CardRequires(
        flags: requiresFlags,
        excludesFlags: excludesFlags,
      ),
      weight: weight,
      once: once,
    );

void main() {
  test('all four meters start at 50', () {
    final GameState state = GameState(endings: _endings, deck: <GameCard>[_card('a')]);
    expect(state.family, 50);
    expect(state.commission, 50);
    expect(state.cops, 50);
    expect(state.cash, 50);
  });

  test('committing left applies the left effects', () {
    final GameState state = GameState(
      endings: _endings,
      deck: <GameCard>[
        _card('a', left: _effects(family: -10, cash: 7, cops: 3)),
      ],
    );

    state.choose(SwipeDirection.left);

    expect(state.family, 40);
    expect(state.cash, 57);
    expect(state.cops, 53);
    expect(state.commission, 50);
  });

  test('committing right applies the right effects', () {
    final GameState state = GameState(
      endings: _endings,
      deck: <GameCard>[
        _card('a', right: _effects(commission: 12, family: -4)),
      ],
    );

    state.choose(SwipeDirection.right);

    expect(state.commission, 62);
    expect(state.family, 46);
  });

  test('meters clamp at 100', () {
    final GameState state = GameState(
      endings: _endings,
      deck: <GameCard>[_card('a', right: _effects(cash: 40))],
    );

    for (int i = 0; i < 5; i++) {
      state.choose(SwipeDirection.right);
    }

    expect(state.cash, 100);
  });

  test('meters clamp at 0', () {
    final GameState state = GameState(
      endings: _endings,
      deck: <GameCard>[_card('a', left: _effects(family: -40))],
    );

    for (int i = 0; i < 5; i++) {
      state.choose(SwipeDirection.left);
    }

    expect(state.family, 0);
  });

  group('blood', () {
    test('starts full and moves no meter when spent', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', right: _effects(blood: 30))],
      );

      expect(state.blood, GameState.bloodMax);

      state.choose(SwipeDirection.right);

      expect(state.blood, GameState.bloodMax - 30);
      expect(state.family, 50);
      expect(state.commission, 50);
      expect(state.cops, 50);
      expect(state.cash, 50);
    });

    test('only ever decreases across a run', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('a', right: _effects(blood: 7)),
          _card('b', right: _effects(blood: 0)),
          _card('c', right: _effects(blood: 12)),
        ],
        random: Random(3),
      );

      int previous = state.blood;
      for (int i = 0; i < 30; i++) {
        state.choose(SwipeDirection.right);
        expect(state.blood, lessThanOrEqualTo(previous));
        previous = state.blood;
      }
    });

    test('floors at zero and never kills', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', right: _effects(blood: 45))],
      );

      for (int i = 0; i < 10; i++) {
        state.choose(SwipeDirection.right);
      }

      expect(state.blood, 0);
      // Draining blood is not an ending: only the four meters can end a run.
      expect(state.isOver, isFalse);
      expect(state.ending, isNull);
    });

    test('is refilled by restart and does not persist', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', right: _effects(blood: 40))],
      );

      state.choose(SwipeDirection.right);
      expect(state.blood, lessThan(GameState.bloodMax));

      state.restart();

      expect(state.blood, GameState.bloodMax);
    });

    test('does not gate card selection', () {
      // A fully drained counter must not remove anything from the pool.
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('a', right: _effects(blood: 50)),
          _card('b', right: _effects(blood: 50)),
        ],
        random: Random(5),
      );

      for (int i = 0; i < 12; i++) {
        state.choose(SwipeDirection.right);
      }

      expect(state.blood, 0);
      expect(state.current.id, anyOf('a', 'b'));
    });
  });

  test('choosing draws a different card and notifies', () {
    int notifications = 0;
    final GameState state = GameState(
      endings: _endings,
      deck: <GameCard>[_card('a'), _card('b'), _card('c')],
      random: Random(7),
    )..addListener(() => notifications++);

    final String before = state.current.id;
    state.choose(SwipeDirection.right);

    expect(state.current.id, isNot(before));
    expect(notifications, 1);
  });

  test('a single-card deck redraws the same card rather than hanging', () {
    final GameState state = GameState(endings: _endings, deck: <GameCard>[_card('only')]);
    state.choose(SwipeDirection.left);
    expect(state.current.id, 'only');
  });

  group('endings', () {
    test('no ending while every meter is between the bounds', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', right: _effects(cash: 10))],
      );

      state.choose(SwipeDirection.right);

      expect(state.ending, isNull);
      expect(state.isOver, isFalse);
    });

    test('a meter hitting 0 ends the run with that meter\'s empty ending', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', left: _effects(family: -50))],
      );

      state.choose(SwipeDirection.left);

      expect(state.isOver, isTrue);
      expect(state.ending!.meter, MeterKind.family);
      expect(state.ending!.bound, MeterBound.empty);
      expect(state.ending!.text, isNotEmpty);
    });

    test('a meter hitting 100 ends the run with that meter\'s full ending', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', right: _effects(cash: 50))],
      );

      state.choose(SwipeDirection.right);

      expect(state.isOver, isTrue);
      expect(state.ending!.meter, MeterKind.cash);
      expect(state.ending!.bound, MeterBound.full);
    });

    test('overshooting a bound still ends the run, clamped', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', left: _effects(cops: -50))],
      );

      state.choose(SwipeDirection.left);

      expect(state.cops, 0);
      expect(state.ending!.meter, MeterKind.cops);
    });

    test('simultaneous bounds resolve in MeterKind order', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('a', right: _effects(family: -50, commission: -50)),
        ],
      );

      state.choose(SwipeDirection.right);

      expect(state.ending!.meter, MeterKind.family);
    });

    test('the card that ended the run stays current', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('killer', right: _effects(family: -50)),
          _card('other'),
        ],
        random: Random(2),
      );

      // Force the killing card to be current regardless of the seed.
      while (state.current.id != 'killer') {
        state.choose(SwipeDirection.left);
      }
      state.choose(SwipeDirection.right);

      expect(state.current.id, 'killer');
    });

    test('swiping after the run is over changes nothing', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', left: _effects(family: -50, cash: -5))],
      );

      state.choose(SwipeDirection.left);
      final int cashAtEnd = state.cash;

      state.choose(SwipeDirection.left);
      state.choose(SwipeDirection.right);

      expect(state.cash, cashAtEnd);
      expect(state.family, 0);
    });
  });

  group('flags', () {
    test('start empty and accumulate from the committed side only', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('a', setsLeft: <String>['at_war'], setsRight: <String>['docks_taken']),
        ],
      );

      expect(state.activeFlags, isEmpty);

      state.choose(SwipeDirection.right);

      expect(state.activeFlags, <String>{'docks_taken'});
      expect(state.activeFlags, isNot(contains('at_war')));
    });

    test('accumulate across swipes', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('a', setsRight: <String>['docks_taken']),
          _card('b', setsRight: <String>['at_war']),
        ],
      );

      state.choose(SwipeDirection.right);
      state.choose(SwipeDirection.right);

      expect(state.activeFlags, containsAll(<String>['docks_taken', 'at_war']));
    });

    test('are cleared by restart', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', setsRight: <String>['docks_taken'])],
      );

      state.choose(SwipeDirection.right);
      expect(state.activeFlags, isNotEmpty);

      state.restart();

      expect(state.activeFlags, isEmpty);
    });

    test('the returned set is not writable from outside', () {
      final GameState state =
          GameState(endings: _endings, deck: <GameCard>[_card('a')]);
      expect(
        () => state.activeFlags.add('at_war'),
        throwsUnsupportedError,
      );
    });
  });

  group('card selection', () {
    test('a card requiring a flag is unreachable until it is set', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('opener', setsRight: <String>['at_war']),
          _card('gated', requiresFlags: <String>['at_war']),
        ],
      );

      // Only the unconditional card can be first.
      expect(state.current.id, 'opener');

      state.choose(SwipeDirection.right);

      // 'opener' is now recent, and 'gated' has become eligible.
      expect(state.current.id, 'gated');
    });

    test('a card requiring a flag stays unreachable if it is never set', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('opener'),
          _card('gated', requiresFlags: <String>['at_war']),
        ],
      );

      for (int i = 0; i < 10; i++) {
        state.choose(SwipeDirection.left);
        expect(state.current.id, 'opener');
      }
    });

    test('an excludesFlags card drops out once that flag is set', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('setter', setsRight: <String>['cop_on_payroll']),
          _card('blocked', excludesFlags: <String>['cop_on_payroll']),
          _card('filler'),
        ],
        random: Random(8),
      );

      // The opening card is drawn at random, so swipe right only when the
      // setter is actually on screen.
      while (!state.activeFlags.contains('cop_on_payroll')) {
        state.choose(
          state.current.id == 'setter'
              ? SwipeDirection.right
              : SwipeDirection.left,
        );
      }

      for (int i = 0; i < 20; i++) {
        expect(state.current.id, isNot('blocked'));
        state.choose(SwipeDirection.left);
      }
    });

    test('a once card is not drawn twice in a run', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('single', once: true),
          _card('filler_a'),
          _card('filler_b'),
        ],
        random: Random(4),
      );

      int seen = 0;
      for (int i = 0; i < 40; i++) {
        if (state.current.id == 'single') seen++;
        state.choose(SwipeDirection.left);
      }

      expect(seen, lessThanOrEqualTo(1));
    });

    test('a once card becomes available again after restart', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('single', once: true)],
      );

      expect(state.current.id, 'single');
      state.choose(SwipeDirection.left);
      state.restart();

      // Nothing else in the deck, so the fallback must still produce it.
      expect(state.current.id, 'single');
    });

    test('weight skews the draw', () {
      // The deck must be comfortably larger than the recency window, or
      // recency — not weight — decides the outcome. See the note on
      // GameState.recentWindow: a heavy card still cannot appear more often
      // than once every recentWindow + 1 draws.
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('heavy', weight: 100),
          for (int i = 0; i < 11; i++) _card('light_$i'),
        ],
        random: Random(9),
      );

      final Map<String, int> counts = <String, int>{};
      for (int i = 0; i < 900; i++) {
        state.choose(SwipeDirection.left);
        counts.update(
          state.current.id,
          (int n) => n + 1,
          ifAbsent: () => 1,
        );
      }

      final int heavy = counts['heavy'] ?? 0;
      final int busiestLight = counts.entries
          .where((MapEntry<String, int> e) => e.key != 'heavy')
          .map((MapEntry<String, int> e) => e.value)
          .reduce((int a, int b) => a > b ? a : b);

      expect(
        heavy,
        greaterThan((busiestLight * 1.5).round()),
        reason: 'heavy=$heavy busiestLight=$busiestLight',
      );
    });

    test('recently played cards are avoided while alternatives exist', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          for (int i = 0; i < 8; i++) _card('c$i'),
        ],
        random: Random(6),
      );

      final List<String> seen = <String>[state.current.id];
      for (int i = 0; i < 30; i++) {
        state.choose(SwipeDirection.left);
        seen.add(state.current.id);
      }

      // No id may repeat inside the recency window.
      for (int i = 0; i < seen.length; i++) {
        final int end = (i + GameState.recentWindow).clamp(0, seen.length - 1);
        for (int j = i + 1; j <= end; j++) {
          expect(seen[i], isNot(seen[j]), reason: 'repeat at $i and $j');
        }
      }
    });

    test('falls back rather than crashing when nothing is eligible', () {
      // Every non-filler card is gated behind a flag that is never set.
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('filler'),
          _card('gated_a', requiresFlags: <String>['at_war']),
          _card('gated_b', requiresFlags: <String>['docks_taken']),
        ],
      );

      for (int i = 0; i < 20; i++) {
        expect(state.current.id, 'filler');
        state.choose(SwipeDirection.left);
      }
    });

    test('a deck of only once cards still returns something once spent', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('one', once: true),
          _card('two', once: true),
        ],
        random: Random(1),
      );

      // Both get spent; selection must not throw or hang afterwards.
      for (int i = 0; i < 10; i++) {
        state.choose(SwipeDirection.left);
        expect(state.current.id, anyOf('one', 'two'));
      }
    });
  });

  group('inheritance', () {
    /// A card whose left side kills via family and costs [blood].
    GameCard fatal({int blood = 0}) =>
        _card('fatal', left: _effects(family: -50, blood: blood));

    test('blood at death picks the heir', () {
      expect(Inheritance.kindFor(100), HeirKind.lovedSon);
      expect(
        Inheritance.kindFor(Inheritance.lovedThreshold),
        HeirKind.lovedSon,
      );
      expect(
        Inheritance.kindFor(Inheritance.lovedThreshold - 1),
        HeirKind.stranger,
      );
      expect(
        Inheritance.kindFor(Inheritance.strangerThreshold),
        HeirKind.stranger,
      );
      expect(
        Inheritance.kindFor(Inheritance.strangerThreshold - 1),
        HeirKind.hatedSon,
      );
      expect(Inheritance.kindFor(0), HeirKind.hatedSon);
    });

    test('the loved son starts strong on family and short on cash', () {
      final Heir heir = Inheritance.of(HeirKind.lovedSon);
      expect(heir.family, greaterThan(heir.cash));
    });

    test('the hated son starts rich and alone', () {
      final Heir heir = Inheritance.of(HeirKind.hatedSon);
      expect(heir.cash, greaterThan(heir.family));
    });

    test('the stranger starts neutral', () {
      final Heir heir = Inheritance.of(HeirKind.stranger);
      expect(heir.family, GameState.startingMeter);
      expect(heir.commission, GameState.startingMeter);
      expect(heir.cops, GameState.startingMeter);
      expect(heir.cash, GameState.startingMeter);
    });

    test('a father who spent everything leaves the hated son', () {
      // Enough blood-costing swipes to drop under the threshold, then death.
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('drain', right: _effects(blood: 45)),
          fatal(),
        ],
        random: Random(2),
      );

      while (state.blood >= Inheritance.strangerThreshold) {
        if (state.current.id == 'drain') {
          state.choose(SwipeDirection.right);
        } else {
          state.choose(SwipeDirection.right); // fatal card's harmless side
        }
      }
      while (!state.isOver) {
        state.choose(
          state.current.id == 'fatal'
              ? SwipeDirection.left
              : SwipeDirection.right,
        );
      }

      expect(state.heir!.kind, HeirKind.hatedSon);
    });

    test('enemies and debts come from the run flags actually set', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('war', setsRight: <String>[GameFlags.atWar]),
          _card('bribe', setsRight: <String>[GameFlags.copOnPayroll]),
          fatal(),
        ],
        random: Random(1),
      );

      while (!state.activeFlags.contains(GameFlags.atWar) ||
          !state.activeFlags.contains(GameFlags.copOnPayroll)) {
        state.choose(SwipeDirection.right);
      }
      while (!state.isOver) {
        state.choose(
          state.current.id == 'fatal'
              ? SwipeDirection.left
              : SwipeDirection.right,
        );
      }
      state.restart();

      expect(state.legacy.enemies, contains('rival_family'));
      expect(state.legacy.debts, contains('detective'));
      expect(
        state.inheritedFlags,
        containsAll(<String>['enemy_rival_family', 'debt_detective']),
      );
    });

    test('inherited flags gate cards for the heir', () {
      final GameState state = GameState(
        endings: _endings,
        legacy: const Legacy(
          enemies: <String>{'rival_family'},
          debts: <String>{},
        ),
        deck: <GameCard>[
          _card('open'),
          _card('inherited', requiresFlags: <String>[
            GameFlags.enemyRivalFamily,
          ]),
        ],
        random: Random(4),
      );

      final Set<String> seen = <String>{state.current.id};
      for (int i = 0; i < 10; i++) {
        state.choose(SwipeDirection.right);
        seen.add(state.current.id);
      }

      expect(seen, contains('inherited'));
    });

    test('memory does not chain past one generation', () {
      // Father earns an enemy. Son earns nothing. The grandson should
      // inherit an empty legacy, not his grandfather's.
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          _card('war', setsRight: <String>[GameFlags.atWar]),
          fatal(),
        ],
        random: Random(6),
      );

      // Father's run: set the flag, then die.
      while (!state.activeFlags.contains(GameFlags.atWar)) {
        state.choose(SwipeDirection.right);
      }
      while (!state.isOver) {
        state.choose(
          state.current.id == 'fatal'
              ? SwipeDirection.left
              : SwipeDirection.right,
        );
      }
      state.restart();
      expect(state.legacy.enemies, contains('rival_family'));

      // Son's run: die without setting anything. Left is the harmless side
      // of 'war' and the lethal side of 'fatal', so swiping left throughout
      // means he earns nothing of his own.
      while (!state.isOver) {
        state.choose(SwipeDirection.left);
      }
      expect(
        state.activeFlags,
        isEmpty,
        reason: 'the son must not have set any flag himself',
      );
      state.restart();

      expect(
        state.legacy.enemies,
        isEmpty,
        reason: 'the grandson inherited his grandfather\'s enemy',
      );
      expect(state.inheritedFlags, isEmpty);
    });

    test('the legacy is written to the store on handover', () async {
      final InMemoryLegacyStore store = InMemoryLegacyStore();
      final GameState state = GameState(
        endings: _endings,
        store: store,
        deck: <GameCard>[
          _card('war', setsRight: <String>[GameFlags.atWar]),
          fatal(),
        ],
        random: Random(8),
      );

      while (!state.activeFlags.contains(GameFlags.atWar)) {
        state.choose(SwipeDirection.right);
      }
      while (!state.isOver) {
        state.choose(
          state.current.id == 'fatal'
              ? SwipeDirection.left
              : SwipeDirection.right,
        );
      }
      state.restart();

      final Legacy saved = await store.load();
      expect(saved.enemies, contains('rival_family'));
    });

    test('inherited flags never become the next legacy on their own', () {
      final Legacy derived = Legacy.fromRunFlags(<String>{
        GameFlags.enemyRivalFamily,
        GameFlags.debtDetective,
      });
      expect(derived.isEmpty, isTrue);
    });
  });

  group('run counter and restart', () {
    test('the first run is run 1', () {
      final GameState state =
          GameState(endings: _endings, deck: <GameCard>[_card('a')]);
      expect(state.runCount, 1);
    });

    test('restart hands over to the heir and counts the run', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', left: _effects(family: -50, cash: -12))],
      );

      state.choose(SwipeDirection.left);
      expect(state.isOver, isTrue);

      // No blood was spent, so the son who loved you takes over.
      final Heir expected = Inheritance.of(HeirKind.lovedSon);
      expect(state.heir!.kind, HeirKind.lovedSon);

      state.restart();

      expect(state.isOver, isFalse);
      expect(state.ending, isNull);
      expect(state.heir, isNull);
      expect(state.family, expected.family);
      expect(state.commission, expected.commission);
      expect(state.cops, expected.cops);
      expect(state.cash, expected.cash);
      expect(state.runCount, 2);
    });

    test('restart notifies and is playable again', () {
      int notifications = 0;
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[_card('a', left: _effects(family: -50, cash: -6))],
      )..addListener(() => notifications++);

      state.choose(SwipeDirection.left);
      state.restart();
      notifications = 0;

      final int cashAtHandover = state.cash;
      state.choose(SwipeDirection.left);

      expect(notifications, 1);
      expect(state.cash, cashAtHandover - 6);
    });
  });

  group('chain delivery', () {
    // A three-beat chain plus enough filler that the pool would never deliver
    // the beats on weight alone.
    List<GameCard> chainDeck({List<String> beat2Excludes = const <String>[]}) =>
        <GameCard>[
          _card('open',
              setsLeft: <String>[GameFlags.atWar],
              setsRight: <String>[GameFlags.atWar],
              weight: 1,
              once: true,
              chain: const CardChain(id: 'open', beat: 1)),
          _card('beat2',
              requiresFlags: <String>[GameFlags.atWar],
              excludesFlags: beat2Excludes,
              setsLeft: <String>[GameFlags.docksTaken],
              setsRight: <String>[GameFlags.docksTaken],
              weight: 1,
              once: true,
              chain: const CardChain(id: 'open', beat: 2)),
          _card('beat3',
              requiresFlags: <String>[GameFlags.docksTaken],
              weight: 1,
              once: true,
              chain: const CardChain(id: 'open', beat: 3)),
          for (int i = 0; i < 40; i++) _card('filler$i', weight: 50),
        ];

    /// Swipes until [id] comes up, or [limit] swipes have passed.
    int swipesUntil(GameState state, String id, {int limit = 40}) {
      for (int i = 0; i < limit; i++) {
        if (state.current.id == id) return i;
        state.choose(SwipeDirection.left);
      }
      return -1;
    }

    test('a resolved opener delivers its follow-up inside the gap', () {
      final GameState state = GameState(
        endings: _endings,
        deck: chainDeck(),
        random: Random(7),
      );
      // Force the opener up: it is the only card carrying a chain.
      expect(swipesUntil(state, 'open'), greaterThanOrEqualTo(0));
      state.choose(SwipeDirection.left);

      // Weight 1 against forty cards at weight 50 — the pool would essentially
      // never produce this, and the gap bounds it to three ordinary cards.
      final int gap = swipesUntil(state, 'beat2', limit: 6);
      expect(gap, inInclusiveRange(GameState.minChainGap, GameState.maxChainGap));
    });

    test('the whole chain arrives, in order', () {
      final GameState state = GameState(
        endings: _endings,
        deck: chainDeck(),
        random: Random(11),
      );
      final List<String> beats = <String>[];
      for (int i = 0; i < 40; i++) {
        if (state.current.chain != null) beats.add(state.current.id);
        state.choose(SwipeDirection.left);
      }
      expect(beats, <String>['open', 'beat2', 'beat3']);
    });

    test('a follow-up never arrives without its opener', () {
      // An ordinary card satisfies beat3's gate, so the weighted pool would
      // have been free to draw the middle of a chain cold.
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          ...chainDeck(),
          _card('setter',
              setsLeft: <String>[GameFlags.docksTaken],
              setsRight: <String>[GameFlags.docksTaken],
              weight: 400),
        ],
        random: Random(3),
      );
      for (int i = 0; i < 30; i++) {
        if (state.current.id == 'open') break;
        expect(state.current.id, isNot('beat2'));
        expect(state.current.id, isNot('beat3'));
        state.choose(SwipeDirection.left);
      }
    });

    test('only one chain is in flight at a time', () {
      final List<GameCard> deck = <GameCard>[
        ...chainDeck(),
        _card('open2',
            setsLeft: <String>[GameFlags.commissionSnubbed],
            setsRight: <String>[GameFlags.commissionSnubbed],
            weight: 500,
            once: true,
            chain: const CardChain(id: 'open2', beat: 1)),
        _card('open2b',
            requiresFlags: <String>[GameFlags.commissionSnubbed],
            weight: 1,
            once: true,
            chain: const CardChain(id: 'open2', beat: 2)),
      ];
      final GameState state =
          GameState(endings: _endings, deck: deck, random: Random(5));
      // open2 is heavy enough to dominate; drive to the first chain then check
      // no second opener appears while a beat is pending.
      while (state.current.chain == null) {
        state.choose(SwipeDirection.left);
      }
      final String first = state.current.chain!.id;
      state.choose(SwipeDirection.left);
      expect(state.chainInFlight, isTrue);
      for (int i = 0; i < 3; i++) {
        expect(state.current.chain?.id ?? first, first,
            reason: 'a second chain opened while one was in flight');
        state.choose(SwipeDirection.left);
      }
    });

    test('a beat contradicted before delivery is dropped, not deferred', () {
      // beat2 excludes a flag the opener itself sets on the left.
      final GameState state = GameState(
        endings: _endings,
        deck: chainDeck(beat2Excludes: <String>[GameFlags.atWar]),
        random: Random(2),
      );
      expect(swipesUntil(state, 'open'), greaterThanOrEqualTo(0));
      state.choose(SwipeDirection.left);

      for (int i = 0; i < 20; i++) {
        expect(state.current.id, isNot('beat2'));
        state.choose(SwipeDirection.left);
      }
      expect(state.beatsDropped, 1);
      // and the chain does not hold the queue shut afterwards
      expect(state.chainInFlight, isFalse);
    });

    test('an opener is forced when no chain has opened by swipe five', () {
      // One opener at weight 1 against forty fillers at weight 50: without the
      // forced draw it would take hundreds of swipes to surface.
      final GameState state = GameState(
        endings: _endings,
        deck: chainDeck(),
        random: Random(99),
      );
      int sawOpenerAt = -1;
      for (int i = 0; i < 12; i++) {
        if (state.current.id == 'open') {
          sawOpenerAt = i;
          break;
        }
        state.choose(SwipeDirection.left);
      }
      expect(sawOpenerAt, greaterThanOrEqualTo(0));
      expect(sawOpenerAt, lessThanOrEqualTo(GameState.forcedOpenerAfter + 1));
    });

    test('restart clears chain state', () {
      final GameState state = GameState(
        endings: _endings,
        deck: <GameCard>[
          ...chainDeck(),
          _card('killer', left: _effects(cash: -100), weight: 1),
        ],
        random: Random(4),
      );
      expect(swipesUntil(state, 'open'), greaterThanOrEqualTo(0));
      state.choose(SwipeDirection.left);
      expect(state.chainInFlight, isTrue);
      expect(state.chainsOpened, 1);

      // kill the run
      while (!state.isOver) {
        if (state.current.id == 'killer') {
          state.choose(SwipeDirection.left);
        } else {
          state.choose(SwipeDirection.right);
        }
      }
      state.restart();

      expect(state.chainInFlight, isFalse);
      expect(state.chainsOpened, 0);
      expect(state.beatsDropped, 0);
    });
  });
}

