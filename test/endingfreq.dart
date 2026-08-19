// ignore_for_file: avoid_print
// Which endings actually fire, over the full 900.  flutter test test/endingfreq.dart
//
// Groundwork for the endings rewrite. Five deaths in an editorial pass is not
// data: if six of the eight rarely fire under normal play, that is a
// distribution problem and rewriting the prose would not touch it.
//
// Drives the real GameState. Three policies, because "normal play" has no
// single definition and the answer may differ by how a person plays.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';
import 'package:mafia_reigns/game_state.dart';

const int kRuns = int.fromEnvironment('runs', defaultValue: 2000);
const int kCap = 500;

List<GameCard> loadDeck() {
  final List<dynamic> raw = <dynamic>[
    for (final String path in CardRepository.deckPaths)
      ...jsonDecode(File(path).readAsStringSync()) as List<dynamic>,
  ];
  return CardRepository.parseDeck(jsonEncode(raw), throwOnInvalid: true);
}

int _total(CardChoice c) =>
    c.effects.family.abs() + c.effects.commission.abs() +
    c.effects.cops.abs() + c.effects.cash.abs();

typedef Policy = SwipeDirection Function(GameState, GameCard, Random);

SwipeDirection random(GameState s, GameCard c, Random r) =>
    r.nextBool() ? SwipeDirection.left : SwipeDirection.right;

/// Steers for the middle but only one card deep — closer to a person than the
/// greedy oracle, which recomputes perfectly and never dies.
SwipeDirection cautious(GameState s, GameCard c, Random r) {
  int score(CardChoice ch) {
    final List<int> after = <int>[
      s.family + ch.effects.family, s.commission + ch.effects.commission,
      s.cops + ch.effects.cops, s.cash + ch.effects.cash,
    ];
    for (final int v in after) {
      if (v <= GameState.minMeter || v >= GameState.maxMeter) return 1 << 20;
    }
    int worst = 0;
    for (final int v in after) {
      worst = max(worst, (v - GameState.startingMeter).abs());
    }
    return worst;
  }
  return score(c.left) <= score(c.right)
      ? SwipeDirection.left : SwipeDirection.right;
}

SwipeDirection reckless(GameState s, GameCard c, Random r) =>
    _total(c.left) >= _total(c.right)
        ? SwipeDirection.left : SwipeDirection.right;

void main() {
  test('which endings fire, over the full 900', () {
    final List<GameCard> deck = loadDeck();
    final EndingSet endings = EndingsRepository.parse(
      File('assets/cards/endings.json').readAsStringSync(),
      throwOnInvalid: true,
    );

    final Map<String, Policy> policies = <String, Policy>{
      'random': random,
      'cautious': cautious,
      'reckless': reckless,
    };

    for (final MapEntry<String, Policy> pol in policies.entries) {
      final Map<String, int> hits = <String, int>{};
      final List<int> lengths = <int>[];
      int alive = 0;
      final Random rng = Random(4242);

      for (int i = 0; i < kRuns; i++) {
        final GameState s =
            GameState(deck: deck, endings: endings, random: rng);
        int swipes = 0;
        while (!s.isOver && swipes < kCap) {
          s.choose(pol.value(s, s.current, rng));
          swipes++;
        }
        lengths.add(swipes);
        final Ending? e = s.ending;
        if (e == null) {
          alive++;
        } else {
          final String k = '${EndingSet.keyFor(e.meter, e.bound)}  ${e.title}';
          hits[k] = (hits[k] ?? 0) + 1;
        }
      }

      lengths.sort();
      print('\n=== $kRuns runs, policy: ${pol.key} ===');
      print('median length ${lengths[kRuns ~/ 2]}   '
          'p10 ${lengths[kRuns ~/ 10]}   p90 ${lengths[kRuns * 9 ~/ 10]}   '
          'survived to cap $alive');
      final List<MapEntry<String, int>> rows = hits.entries.toList()
        ..sort((MapEntry<String, int> a, MapEntry<String, int> b) =>
            b.value.compareTo(a.value));
      for (final MapEntry<String, int> r in rows) {
        final double pct = r.value * 100 / kRuns;
        print('  ${r.key.padRight(34)} ${r.value.toString().padLeft(5)}  '
            '${pct.toStringAsFixed(1)}%');
      }
      final int missing = 8 - hits.length;
      if (missing > 0) print('  *** $missing of 8 endings never fired ***');
    }
  });
}
