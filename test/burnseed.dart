// ignore_for_file: avoid_print
// Seed search for the playtest's last run.  flutter test test/burnseed.dart
//
// The session's final run is meant to show a person a long storyline, so it
// needs a seed under which a six-beat burn actually opens and finishes. Under
// random play a burn is met in a few runs per hundred, which a session cannot
// wait for.
//
// A seed fixes the draw but not the player, so a seed is only useful if it
// survives *different* play. Each candidate is therefore tried under five
// policies — three random players with different coins, and the two degenerate
// ones that always swipe the same way — and only a seed that opens the burn
// under all five is worth using.
//
// Drives the real GameState, like test/simulate.dart, so this cannot drift
// from what ships.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';
import 'package:mafia_reigns/game_state.dart';

/// The two recorded six-beat burns. `b6_076` is the practical target: its
/// opener is flag-free, so it is eligible for the forced-opener rule in any
/// run. `b3_076` needs `sally_humiliated` first.
const Set<String> kBurns = <String>{'b3_076', 'b6_076'};

const int kCap = 500;

List<GameCard> loadDeck() {
  final List<dynamic> raw = <dynamic>[
    for (final String path in CardRepository.deckPaths)
      ...jsonDecode(File(path).readAsStringSync()) as List<dynamic>,
  ];
  return CardRepository.parseDeck(jsonEncode(raw), throwOnInvalid: true);
}

/// A way of playing. Returns the side to take.
typedef Policy = SwipeDirection Function(GameState s, GameCard c, Random coin);

/// Steers for the middle — the closest of these to a careful human.
SwipeDirection careful(GameState s, GameCard card, Random coin) {
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
    return worst;
  }

  return score(card.left) <= score(card.right)
      ? SwipeDirection.left
      : SwipeDirection.right;
}

class Outcome {
  Outcome(this.swipes, this.burnOpened, this.burnTopBeat, this.burnDone);
  final int swipes;
  final String? burnOpened;
  final int burnTopBeat;
  final bool burnDone;
}

Outcome play(List<GameCard> deck, EndingSet endings, int seed, Policy policy,
    int coinSeed, Map<String, int> lengths) {
  final GameState s =
      GameState(deck: deck, endings: endings, random: Random(seed));
  final Random coin = Random(coinSeed);
  String? opened;
  int top = 0;
  int swipes = 0;
  while (!s.isOver && swipes < kCap) {
    final GameCard card = s.current;
    final CardChain? ch = card.chain;
    if (ch != null && kBurns.contains(ch.id)) {
      opened = ch.id;
      if (ch.beat > top) top = ch.beat;
    }
    s.choose(policy(s, card, coin));
    swipes++;
  }
  final bool done = opened != null && top == lengths[opened];
  return Outcome(swipes, opened, top, done);
}

void main() {
  test('find a seed that delivers a six-beat burn under any play', () {
    final List<GameCard> deck = loadDeck();
    final EndingSet endings = EndingsRepository.parse(
      File('assets/cards/endings.json').readAsStringSync(),
      throwOnInvalid: true,
    );
    final Map<String, int> lengths = <String, int>{};
    for (final GameCard c in deck) {
      final CardChain? ch = c.chain;
      if (ch != null) lengths[ch.id] = max(lengths[ch.id] ?? 0, ch.beat);
    }

    final Map<String, Policy> policies = <String, Policy>{
      'careful': careful,
      'coin-a': (GameState s, GameCard c, Random r) =>
          r.nextBool() ? SwipeDirection.left : SwipeDirection.right,
      'coin-b': (GameState s, GameCard c, Random r) =>
          r.nextBool() ? SwipeDirection.left : SwipeDirection.right,
      'coin-c': (GameState s, GameCard c, Random r) =>
          r.nextBool() ? SwipeDirection.left : SwipeDirection.right,
      'all-left': (GameState s, GameCard c, Random r) => SwipeDirection.left,
      'all-right': (GameState s, GameCard c, Random r) => SwipeDirection.right,
    };

    final List<Map<String, Object>> best = <Map<String, Object>>[];

    for (int seed = 1; seed <= 4000; seed++) {
      int opens = 0;
      int completes = 0;
      int coinSeed = 11;
      final List<String> detail = <String>[];
      for (final MapEntry<String, Policy> e in policies.entries) {
        final Outcome o =
            play(deck, endings, seed, e.value, coinSeed++, lengths);
        if (o.burnOpened != null) opens++;
        if (o.burnDone) completes++;
        detail.add('${e.key}:${o.burnOpened ?? '-'}'
            '/b${o.burnTopBeat}/${o.swipes}sw');
      }
      if (opens == policies.length) {
        best.add(<String, Object>{
          'seed': seed,
          'opens': opens,
          'completes': completes,
          'detail': detail.join('  '),
        });
      }
    }

    best.sort((Map<String, Object> a, Map<String, Object> b) =>
        (b['completes']! as int).compareTo(a['completes']! as int));

    print('\nseeds where the burn opens under all ${policies.length} policies: '
        '${best.length} of 4000');
    for (final Map<String, Object> row in best.take(12)) {
      print('  seed ${row['seed']}  completes '
          '${row['completes']}/${policies.length}');
      print('      ${row['detail']}');
    }
    expect(best, isNotEmpty, reason: 'no robust burn seed found');
  });
}
