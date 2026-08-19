// ignore_for_file: avoid_print
// Blood and succession measurement.  flutter test test/blood.dart
//
// Separate from simulate.dart because it asks a different question. That one
// measures how the deck is delivered; this one measures what blood does, and it
// needs policies that steer on blood rather than on survival.
//
// Blood's only consumer is the heir, so if the thresholds do not split the
// population the mechanic is invisible. And before moving any threshold it is
// worth knowing whether blood-at-death is a record of how the player *played*
// or merely of how long they lasted — thresholds cannot fix the second.

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

List<GameCard> loadDeck() {
  final List<dynamic> raw = <dynamic>[
    for (final String path in CardRepository.deckPaths)
      ...jsonDecode(File(path).readAsStringSync()) as List<dynamic>,
  ];
  return CardRepository.parseDeck(jsonEncode(raw), throwOnInvalid: true);
}

final EndingSet endings = EndingsRepository.parse(
  File('assets/cards/endings.json').readAsStringSync(),
  throwOnInvalid: true,
);

enum Policy { random, restraint, spendthrift, greedy }

SwipeDirection decide(Policy p, GameState s, GameCard c, Random rng) {
  final int lb = c.left.effects.blood, rb = c.right.effects.blood;
  switch (p) {
    case Policy.random:
      return rng.nextBool() ? SwipeDirection.left : SwipeDirection.right;
    case Policy.restraint:
      if (lb != rb) return lb < rb ? SwipeDirection.left : SwipeDirection.right;
      return rng.nextBool() ? SwipeDirection.left : SwipeDirection.right;
    case Policy.spendthrift:
      if (lb != rb) return lb > rb ? SwipeDirection.left : SwipeDirection.right;
      return rng.nextBool() ? SwipeDirection.left : SwipeDirection.right;
    case Policy.greedy:
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
        return worst * 4 + ch.effects.blood;
      }

      return score(c.left) <= score(c.right)
          ? SwipeDirection.left
          : SwipeDirection.right;
  }
}

class Run {
  Run(this.swipes, this.blood, this.died);
  final int swipes;
  final int blood;
  final bool died;
  int get lost => GameState.bloodMax - blood;
}

List<Run> playAll(List<GameCard> deck, Policy p, int seed) {
  final Random rng = Random(seed);
  return <Run>[
    for (int i = 0; i < kRuns; i++) () {
      final GameState s = GameState(deck: deck, endings: endings, random: rng);
      int n = 0;
      while (!s.isOver && n < kCap) {
        s.choose(decide(p, s, s.current, rng));
        n++;
      }
      return Run(n, s.blood, s.isOver);
    }(),
  ];
}

List<int> deciles(List<int> xs) {
  final List<int> s = List<int>.from(xs)..sort();
  return <int>[for (int i = 0; i <= 10; i++) s[min(s.length - 1, s.length * i ~/ 10)]];
}

double mean(Iterable<num> xs) =>
    xs.isEmpty ? 0 : xs.fold<num>(0, (num a, num b) => a + b) / xs.length;

/// Pearson r between run length and blood lost.
double correlation(List<Run> rs) {
  final double mx = mean(rs.map((Run r) => r.swipes));
  final double my = mean(rs.map((Run r) => r.lost));
  double sxy = 0, sxx = 0, syy = 0;
  for (final Run r in rs) {
    final double dx = r.swipes - mx, dy = r.lost - my;
    sxy += dx * dy;
    sxx += dx * dx;
    syy += dy * dy;
  }
  return sxx == 0 || syy == 0 ? 0 : sxy / sqrt(sxx * syy);
}

void main() {
  test('what blood records, and where the thresholds should sit', () {
    final List<GameCard> deck = loadDeck();

    // ---- how the deck offers blood at all -----------------------------
    int oneSided = 0, twoSided = 0, none = 0;
    for (final GameCard c in deck) {
      final int l = c.left.effects.blood, r = c.right.effects.blood;
      if (l == 0 && r == 0) {
        none++;
      } else if (l > 0 && r > 0) {
        twoSided++;
      } else {
        oneSided++;
      }
    }
    print('\n=== how the deck offers blood (${deck.length} cards) ===');
    print('  no blood on either side   $none');
    print('  blood on ONE side only    $oneSided   (avoidable by choosing)');
    print('  blood on BOTH sides       $twoSided   (unavoidable)');

    // ---- the question: choice, or run length? -------------------------
    final Map<Policy, List<Run>> byPolicy = <Policy, List<Run>>{
      for (final Policy p in Policy.values) p: playAll(deck, p, 20260817),
    };

    print('\n=== is blood-at-death a record of play, or of run length? ===');
    print('  policy        deaths  median  mean    blood lost   blood lost');
    print('                        length  blood   per run      PER SWIPE');
    for (final Policy p in Policy.values) {
      final List<Run> rs = byPolicy[p]!;
      final List<Run> died = rs.where((Run r) => r.died).toList();
      final double perSwipe = mean(rs.map((Run r) => r.lost)) / mean(rs.map((Run r) => r.swipes));
      print('  ${p.name.padRight(13)} ${died.length.toString().padLeft(5)}'
          '   ${(List<int>.from(rs.map((Run r) => r.swipes))..sort())[rs.length ~/ 2].toString().padLeft(5)}'
          '   ${mean(died.map((Run r) => r.blood)).toStringAsFixed(1).padLeft(5)}'
          '   ${mean(rs.map((Run r) => r.lost)).toStringAsFixed(1).padLeft(9)}'
          '   ${perSwipe.toStringAsFixed(3).padLeft(9)}');
    }

    final List<Run> rnd = byPolicy[Policy.random]!;
    final double r = correlation(rnd);
    print('\n  random play: correlation(run length, blood lost) r = '
        '${r.toStringAsFixed(3)}, r2 = ${(r * r).toStringAsFixed(3)}');

    // Within a narrow run-length band, how much does blood still vary? If
    // length explained everything this spread would collapse.
    for (final List<int> band in <List<int>>[<int>[20, 25], <int>[26, 32], <int>[40, 50]]) {
      final List<Run> in_ = rnd
          .where((Run x) => x.swipes >= band[0] && x.swipes <= band[1])
          .toList();
      if (in_.length < 20) continue;
      final List<int> b = in_.map((Run x) => x.blood).toList()..sort();
      print('  runs of ${band[0]}-${band[1]} swipes (n=${in_.length}): '
          'blood p10 ${b[b.length ~/ 10]}, median ${b[b.length ~/ 2]}, '
          'p90 ${b[b.length * 9 ~/ 10]}  (spread ${b[b.length * 9 ~/ 10] - b[b.length ~/ 10]})');
    }

    // ---- the distribution the thresholds have to split ----------------
    print('\n=== blood at death, random play, $kRuns runs ===');
    for (final Policy p in <Policy>[Policy.random, Policy.restraint, Policy.spendthrift]) {
      final List<Run> died = byPolicy[p]!.where((Run x) => x.died).toList();
      final List<int> d = deciles(died.map((Run x) => x.blood).toList());
      print('  ${p.name.padRight(12)} deciles: ${d.join('  ')}');
    }

    // ---- what the current thresholds do, and what would fit -----------
    List<int> split(List<Run> rs, int loved, int stranger) {
      int a = 0, b = 0, c = 0;
      for (final Run x in rs.where((Run x) => x.died)) {
        if (x.blood >= loved) {
          a++;
        } else if (x.blood >= stranger) {
          b++;
        } else {
          c++;
        }
      }
      return <int>[a, b, c];
    }

    print('\n=== threshold candidates against random play ===');
    print('  loved/stranger    lovedSon  stranger  hatedSon');
    final List<List<int>> candidates = <List<int>>[
      <int>[Inheritance.lovedThreshold, Inheritance.strangerThreshold],
    ];
    final List<int> died =
        rnd.where((Run x) => x.died).map((Run x) => x.blood).toList()..sort();
    final int t1 = died[died.length * 2 ~/ 3]; // upper third boundary
    final int t2 = died[died.length ~/ 3];
    candidates.add(<int>[t1, t2]);
    for (final int a in <int>[80, 82, 85, 88, 90]) {
      for (final int b in <int>[62, 65, 68, 70, 72]) {
        candidates.add(<int>[a, b]);
      }
    }
    for (final List<int> c in candidates) {
      final List<int> s = split(rnd, c[0], c[1]);
      final int n = s[0] + s[1] + s[2];
      final String mark = c[0] == Inheritance.lovedThreshold &&
              c[1] == Inheritance.strangerThreshold
          ? '   <-- shipped'
          : (c[0] == t1 && c[1] == t2 ? '   <-- exact thirds' : '');
      print('  ${c[0].toString().padLeft(3)} / ${c[1].toString().padLeft(3)}'
          '        ${(100 * s[0] / n).toStringAsFixed(1).padLeft(5)}%'
          '     ${(100 * s[1] / n).toStringAsFixed(1).padLeft(5)}%'
          '     ${(100 * s[2] / n).toStringAsFixed(1).padLeft(5)}%$mark');
    }

    print('\n=== the same candidates against restraint and spendthrift ===');
    for (final Policy p in <Policy>[Policy.restraint, Policy.spendthrift]) {
      final List<int> s = split(byPolicy[p]!, t1, t2);
      final int n = s[0] + s[1] + s[2];
      print('  ${p.name.padRight(12)} at $t1/$t2: '
          '${(100 * s[0] / n).toStringAsFixed(1)}% / '
          '${(100 * s[1] / n).toStringAsFixed(1)}% / '
          '${(100 * s[2] / n).toStringAsFixed(1)}%');
    }
  }, timeout: const Timeout(Duration(minutes: 10)));
}
