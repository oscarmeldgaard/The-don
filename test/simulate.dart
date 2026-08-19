// ignore_for_file: avoid_print
// Deck measurement harness.  flutter test test/simulate.dart
//
// Deliberately not named *_test.dart: `flutter test` collects that pattern, and
// this takes seconds rather than milliseconds and asserts almost nothing. It is
// a measuring instrument, not a guard.
//
// It drives the **real** [GameState], so it cannot drift from what ships the
// way a reimplemented draw loop would. Run it whenever deck structure changes;
// the numbers land in docs/content-bible.md.
//
// `--dart-define=runs=200` to go faster while iterating.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';
import 'package:mafia_reigns/game_state.dart';
import 'package:mafia_reigns/heir.dart';

const int kRuns = int.fromEnvironment('runs', defaultValue: 1000);
const int kCap = 500;

/// Loads the shipped deck. With [withChains] false the `chain` key is dropped,
/// which reproduces the pre-queue draw exactly: `_advanceChain` does nothing,
/// every card is drawable, and the forced opener finds no openers to force.
List<GameCard> loadDeck({required bool withChains}) {
  final List<dynamic> raw = <dynamic>[
    for (final String path in CardRepository.deckPaths)
      ...jsonDecode(File(path).readAsStringSync()) as List<dynamic>,
  ];
  if (!withChains) {
    for (final dynamic c in raw) {
      (c as Map<String, dynamic>).remove('chain');
    }
  }
  return CardRepository.parseDeck(jsonEncode(raw), throwOnInvalid: true);
}

final EndingSet endings = EndingsRepository.parse(
  File('assets/cards/endings.json').readAsStringSync(),
  throwOnInvalid: true,
);

/// Total beats in each chain, so a run can tell a finished chain from an
/// abandoned one.
Map<String, int> chainLengths(List<GameCard> deck) {
  final Map<String, int> out = <String, int>{};
  for (final GameCard c in deck) {
    final CardChain? ch = c.chain;
    if (ch == null) continue;
    out[ch.id] = max(out[ch.id] ?? 0, ch.beat);
  }
  return out;
}

class RunResult {
  RunResult(this.swipes, this.ending, this.blood, this.heir, this.beats,
      this.opened, this.completed, this.vices, this.dropped);
  final int swipes;
  final Ending? ending; // null when the run reached the cap alive
  final int blood;
  final Heir? heir;
  final int beats;
  final int opened;
  final int completed;
  final int vices;
  final int dropped;
  final List<int> completedLengths = <int>[];
  int burnOpened = 0;
  int burnCompleted = 0;
}

/// Steers for the middle: takes the side that leaves the worst meter closest
/// to 50, treating a side that ends the run as infinitely bad. This is the
/// oracle — it recomputes perfectly on every card and no human plays like it.
SwipeDirection greedy(GameState s, GameCard card) {
  int score(CardChoice ch) {
    final List<int> after = <int>[
      s.family + ch.effects.family,
      s.commission + ch.effects.commission,
      s.cops + ch.effects.cops,
      s.cash + ch.effects.cash,
    ];
    for (final int v in after) {
      if (v <= GameState.minMeter || v >= GameState.maxMeter) return 1 << 20;
    }
    int worst = 0;
    for (final int v in after) {
      worst = max(worst, (v - GameState.startingMeter).abs());
    }
    // Blood breaks ties only: it cannot kill, and spending it to survive is
    // correct play.
    return worst * 4 + ch.effects.blood;
  }

  return score(card.left) <= score(card.right)
      ? SwipeDirection.left
      : SwipeDirection.right;
}

RunResult play(List<GameCard> deck, Map<String, int> lengths, Random rng,
    {required bool greedyPolicy}) {
  final GameState s = GameState(deck: deck, endings: endings, random: rng);
  final Map<String, int> beatsSeen = <String, int>{};
  int swipes = 0, beats = 0, vices = 0;

  while (!s.isOver && swipes < kCap) {
    final GameCard card = s.current;
    if (card.vice) vices++;
    final CardChain? ch = card.chain;
    if (ch != null) {
      beats++;
      beatsSeen[ch.id] = max(beatsSeen[ch.id] ?? 0, ch.beat);
    }
    s.choose(greedyPolicy
        ? greedy(s, card)
        : (rng.nextBool() ? SwipeDirection.left : SwipeDirection.right));
    swipes++;
  }

  int completed = 0;
  final List<int> doneLengths = <int>[];
  int burnOpened = 0, burnDone = 0;
  const Set<String> burns = <String>{'b3_076', 'b6_076'};
  beatsSeen.forEach((String id, int high) {
    if (burns.contains(id)) burnOpened++;
    if (high == lengths[id]) {
      completed++;
      doneLengths.add(high);
      if (burns.contains(id)) burnDone++;
    }
  });
  final RunResult r = RunResult(swipes, s.ending, s.blood, s.heir, beats,
      beatsSeen.length, completed, vices, s.beatsDropped);
  r.completedLengths.addAll(doneLengths);
  r.burnOpened = burnOpened;
  r.burnCompleted = burnDone;
  return r;
}

int median(List<int> xs) {
  final List<int> s = List<int>.from(xs)..sort();
  return s[s.length ~/ 2];
}

double mean(Iterable<num> xs) =>
    xs.isEmpty ? 0 : xs.fold<num>(0, (num a, num b) => a + b) / xs.length;

String pct(num n, num of) => '${(100 * n / of).toStringAsFixed(1)}%';

void report(String label, List<RunResult> rs) {
  final int died = rs.where((RunResult r) => r.ending != null).length;
  final List<int> lengths = rs.map((RunResult r) => r.swipes).toList();
  print('\n--- $label  ($kRuns runs, $kCap-swipe cap) ---');
  print('  survived to cap        ${rs.length - died} / ${rs.length}');
  print('  median run length      ${median(lengths)}');
  print('  p10 / p90 length       ${(List<int>.from(lengths)..sort())[rs.length ~/ 10]}'
      ' / ${(List<int>.from(lengths)..sort())[rs.length * 9 ~/ 10]}');
  print('  mean beats per run     ${mean(rs.map((RunResult r) => r.beats)).toStringAsFixed(2)}');
  print('  chain beats as share   '
      '${pct(mean(rs.map((RunResult r) => r.beats)), mean(lengths))} of cards seen');
  print('  chains opened / run    ${mean(rs.map((RunResult r) => r.opened)).toStringAsFixed(2)}');
  print('  chains COMPLETED / run ${mean(rs.map((RunResult r) => r.completed)).toStringAsFixed(2)}');
  print('  beats dropped / run    ${mean(rs.map((RunResult r) => r.dropped)).toStringAsFixed(3)}');
  print('  vices met / run        ${mean(rs.map((RunResult r) => r.vices)).toStringAsFixed(2)}');
  print('  blood at death (mean)  ${mean(rs.where((RunResult r) => r.ending != null).map((RunResult r) => r.blood)).toStringAsFixed(1)}');

  final Map<String, int> causes = <String, int>{};
  for (final RunResult r in rs) {
    final Ending? e = r.ending;
    if (e == null) continue;
    final String k = '${e.meter.name}.${e.bound.name}';
    causes[k] = (causes[k] ?? 0) + 1;
  }
  print('  cause of death:');
  final List<MapEntry<String, int>> sorted = causes.entries.toList()
    ..sort((MapEntry<String, int> a, MapEntry<String, int> b) =>
        b.value.compareTo(a.value));
  for (final MapEntry<String, int> e in sorted) {
    final String warn = e.value / died > 0.25 ? '   <-- over 25%' : '';
    print('    ${e.key.padRight(20)} ${e.value.toString().padLeft(4)}'
        '  ${pct(e.value, died).padLeft(6)}$warn');
  }
  for (final MeterKind m in MeterKind.values) {
    for (final MeterBound b in MeterBound.values) {
      if (!causes.containsKey('${m.name}.${b.name}')) {
        print('    ${'${m.name}.${b.name}'.padRight(20)}   0   UNREACHABLE');
      }
    }
  }

  final Map<String, int> heirs = <String, int>{};
  for (final RunResult r in rs) {
    if (r.heir == null) continue;
    // Keyed on kind, not name: the loved son and the hated son are the same
    // boy and share the name NICKY, so keying on name silently merges two of
    // the three outcomes and reports a mechanic as dead that is merely rare.
    final String k = '${r.heir!.kind.name} (${r.heir!.name})';
    heirs[k] = (heirs[k] ?? 0) + 1;
  }
  final Map<int, int> byLen = <int, int>{};
  for (final RunResult r in rs) {
    for (final int n in r.completedLengths) {
      byLen[n] = (byLen[n] ?? 0) + 1;
    }
  }
  final List<int> ks = byLen.keys.toList()..sort();
  print('  completed chains by length: '
      '${ks.map((int k) => '$k-beat x${byLen[k]}').join('  ')}');
  int burnsOpened = 0, burnsDone = 0;
  for (final RunResult r in rs) {
    burnsOpened += r.burnOpened;
    burnsDone += r.burnCompleted;
  }
  print('  six-beat burns opened $burnsOpened, completed $burnsDone '
      'in ${rs.length} runs');
  print('  heir at death:');
  for (final MapEntry<String, int> e in heirs.entries) {
    print('    ${e.key.padRight(20)} ${e.value.toString().padLeft(4)}  ${pct(e.value, died)}');
  }
}

void main() {
  test('measure the deck, with chains queued and without', () {
    for (final bool withChains in <bool>[false, true]) {
      final List<GameCard> deck = loadDeck(withChains: withChains);
      final Map<String, int> lengths = chainLengths(loadDeck(withChains: true));
      final String label = withChains ? 'WITH the queue' : 'BEFORE (weighted draw only)';
      for (final bool greedyPolicy in <bool>[false, true]) {
        final Random rng = Random(20260817);
        final List<RunResult> rs = <RunResult>[
          for (int i = 0; i < kRuns; i++)
            play(deck, lengths, rng, greedyPolicy: greedyPolicy),
        ];
        report('$label — ${greedyPolicy ? "greedy oracle" : "random floor"}', rs);
      }
    }
  }, timeout: const Timeout(Duration(minutes: 10)));
}
