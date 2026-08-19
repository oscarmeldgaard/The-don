// The two playtest hooks. Both must be inert when off and honest when on.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';
import 'package:mafia_reigns/game_state.dart';
import 'package:mafia_reigns/playtest.dart';

List<GameCard> shippedDeck() {
  final List<dynamic> raw = <dynamic>[
    for (final String path in CardRepository.deckPaths)
      ...jsonDecode(File(path).readAsStringSync()) as List<dynamic>,
  ];
  return CardRepository.parseDeck(jsonEncode(raw), throwOnInvalid: true);
}

EndingSet shippedEndings() => EndingsRepository.parse(
      File('assets/cards/endings.json').readAsStringSync(),
      throwOnInvalid: true,
    );

void main() {
  group('PlaytestConfig', () {
    test('is off for a plain URL, which is what a shipped build has', () {
      final PlaytestConfig c =
          PlaytestConfig.fromUri(Uri.parse('http://localhost:8080/'));
      expect(c.isOn, isFalse);
      expect(c.seed, isNull);
      expect(c.trace, isFalse);
      expect(c.random, isNull);
    });

    test('reads both hooks and the label off the query string', () {
      final PlaytestConfig c = PlaytestConfig.fromUri(
        Uri.parse('http://localhost:8080/?trace=1&seed=100&label=burn'),
      );
      expect(c.trace, isTrue);
      expect(c.seed, 100);
      expect(c.label, 'burn');
      expect(c.random, isA<Random>());
    });

    test('ignores a seed that is not a number rather than crashing a session',
        () {
      final PlaytestConfig c =
          PlaytestConfig.fromUri(Uri.parse('http://x/?seed=banana'));
      expect(c.seed, isNull);
      expect(c.random, isNull);
    });
  });

  group('the trace', () {
    test('records one entry per swipe, with the label the player read', () {
      final RunTrace trace =
          RunTrace(config: const PlaytestConfig(trace: true, seed: 7));
      final GameState s = GameState(
        deck: shippedDeck(),
        endings: shippedEndings(),
        random: Random(7),
        trace: trace,
      );

      final String firstId = s.current.id;
      final String firstLabel = s.current.left.label;
      s.choose(SwipeDirection.left);
      s.choose(SwipeDirection.right);

      expect(trace.current.swipes, hasLength(2));
      final TraceEntry first = trace.current.swipes.first;
      expect(first.swipe, 1);
      expect(first.cardId, firstId);
      expect(first.direction, 'left');
      expect(first.label, firstLabel);
      expect(trace.current.swipes[1].direction, 'right');
    });

    test('records meters *after* the swipe, so a death is legible', () {
      final RunTrace trace =
          RunTrace(config: const PlaytestConfig(trace: true));
      final GameState s = GameState(
        deck: shippedDeck(),
        endings: shippedEndings(),
        random: Random(3),
        trace: trace,
      );
      final int before = s.family;
      final int delta = s.current.left.effects.family;
      s.choose(SwipeDirection.left);
      expect(trace.current.swipes.single.family, (before + delta).clamp(0, 100));
    });

    test('closes the run with the ending, the heir and the blood left', () {
      final RunTrace trace =
          RunTrace(config: const PlaytestConfig(trace: true));
      final GameState s = GameState(
        deck: shippedDeck(),
        endings: shippedEndings(),
        random: Random(11),
        trace: trace,
      );
      final Random coin = Random(11);
      int guard = 0;
      while (!s.isOver && guard++ < 500) {
        s.choose(coin.nextBool() ? SwipeDirection.left : SwipeDirection.right);
      }
      expect(s.isOver, isTrue, reason: 'run should have ended inside the cap');
      expect(trace.runs, hasLength(1));
      final RunRecord r = trace.runs.single;
      expect(r.endingId, isNotNull);
      expect(r.endingTitle, isNotNull);
      expect(r.heir, isNotNull);
      expect(r.bloodAtDeath, isNotNull);
      expect(r.length, greaterThan(0));
      expect(jsonDecode(jsonEncode(r.toJson())), isA<Map<String, dynamic>>());
    });

    test('starts a fresh record when the heir takes over', () {
      final RunTrace trace =
          RunTrace(config: const PlaytestConfig(trace: true));
      final GameState s = GameState(
        deck: shippedDeck(),
        endings: shippedEndings(),
        random: Random(11),
        trace: trace,
      );
      final Random coin = Random(11);
      int guard = 0;
      while (!s.isOver && guard++ < 500) {
        s.choose(coin.nextBool() ? SwipeDirection.left : SwipeDirection.right);
      }
      s.restart();
      expect(trace.runs, hasLength(1));
      expect(trace.current.run, 2);
      expect(trace.current.swipes, isEmpty);
    });

    test('a null trace changes nothing: the shipped build path still plays',
        () {
      final GameState s = GameState(
        deck: shippedDeck(),
        endings: shippedEndings(),
        random: Random(5),
      );
      expect(() => s.choose(SwipeDirection.left), returnsNormally);
      expect(s.current, isA<GameCard>());
    });
  });

  group('the seed', () {
    test('two states on the same seed and the same choices agree exactly', () {
      List<String> run(int seed) {
        final GameState s = GameState(
          deck: shippedDeck(),
          endings: shippedEndings(),
          random: Random(seed),
        );
        final List<String> ids = <String>[];
        final Random coin = Random(99);
        int guard = 0;
        while (!s.isOver && guard++ < 60) {
          ids.add(s.current.id);
          s.choose(coin.nextBool() ? SwipeDirection.left : SwipeDirection.right);
        }
        return ids;
      }

      expect(run(100), equals(run(100)));
      expect(run(100), isNot(equals(run(101))));
    });

    test('seed 100 opens the six-beat burn, which is what the last run is for',
        () {
      // Chosen by test/burnseed.dart: of 4000 seeds it is the only one where
      // b6_076 opens under all 27 play policies tried, and it completes under
      // 24 of them. The session's final run depends on this.
      final GameState s = GameState(
        deck: shippedDeck(),
        endings: shippedEndings(),
        random: Random(100),
      );
      final Random coin = Random(11);
      final Set<String> chainsSeen = <String>{};
      int guard = 0;
      while (!s.isOver && guard++ < 500) {
        final CardChain? c = s.current.chain;
        if (c != null) chainsSeen.add(c.id);
        s.choose(coin.nextBool() ? SwipeDirection.left : SwipeDirection.right);
      }
      expect(chainsSeen, contains('b6_076'));
    });
  });
}
