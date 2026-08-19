import 'package:flutter/foundation.dart';

/// Who takes over when the father dies.
enum HeirKind { lovedSon, stranger, hatedSon }

@immutable
class Heir {
  const Heir({
    required this.kind,
    required this.name,
    required this.line,
    required this.family,
    required this.commission,
    required this.cops,
    required this.cash,
  });

  final HeirKind kind;

  /// Shown on the game-over screen.
  final String name;

  /// One line describing what he is to you.
  final String line;

  /// What he starts the next run with.
  final int family;
  final int commission;
  final int cops;
  final int cash;
}

/// Turns the father's remaining blood into his heir.
///
/// Blood is spent by choosing the business over the wife, the son or the
/// brother. So a father who ends with blood intact is one whose son still
/// loves him; a father who spent it all leaves a son who does not.
class Inheritance {
  const Inheritance._();

  // Both thresholds were re-derived after batch 6, measured rather than
  // guessed, and the guess had been badly wrong. At 60/20 the split across
  // 1,000 random runs was **80.5% / 17.0% / 2.5%**: the loved son was the
  // default, the hated son fired once in forty, and two-thirds of the only
  // mechanism blood feeds had never been seen. The original comment reasoned
  // from a 23-card placeholder deck — "ten of twenty-three cards can cost
  // blood" — and the real 600 carry blood on 102, which is a far lower rate.
  //
  // The thresholds moved to fit the distribution rather than the other way
  // round: blood lands where the content puts it, and has been budgeted at
  // the chain level since batch 6.
  //
  // Blood at death across 1,000 random runs, by decile:
  //
  //     0  47  60  69  75  81  84  91  92  100  100
  //
  // 88 and 70 cut that into 34.3% / 34.5% / 31.2%.

  /// Blood at or above this leaves the son who loved you.
  ///
  /// Twelve points of blood is roughly one heavy card or two ordinary ones, so
  /// this is the father who was asked and mostly said no.
  static const int lovedThreshold = 88;

  /// Blood at or above this (but below [lovedThreshold]) leaves the stranger.
  /// Below it, the son who hated you.
  ///
  /// Thirty points is three or four family-costing choices — enough that the
  /// hated son is still earned, but reachable inside a median run of 28 swipes
  /// rather than only by the rare father who spends everything.
  static const int strangerThreshold = 70;

  static HeirKind kindFor(int blood) {
    if (blood >= lovedThreshold) return HeirKind.lovedSon;
    if (blood >= strangerThreshold) return HeirKind.stranger;
    return HeirKind.hatedSon;
  }

  static Heir forBlood(int blood) => of(kindFor(blood));

  static Heir of(HeirKind kind) {
    switch (kind) {
      case HeirKind.lovedSon:
        return const Heir(
          kind: HeirKind.lovedSon,
          name: 'NICKY',
          line:
              'He buried you properly, and cried where the crew could not '
              'see it. They follow him because he is yours. He has never had '
              'to earn a dollar in his life.',
          family: 70,
          commission: 50,
          cops: 50,
          cash: 30,
        );
      case HeirKind.stranger:
        return const Heir(
          kind: HeirKind.stranger,
          name: 'CARMINE',
          line:
              'The Commission sent him. He owes you nothing and is owed '
              'nothing, and every man at the table is waiting to see which '
              'of those two facts matters more.',
          family: 50,
          commission: 50,
          cops: 50,
          cash: 50,
        );
      case HeirKind.hatedSon:
        return const Heir(
          kind: HeirKind.hatedSon,
          name: 'NICKY',
          line:
              'He took the business the way a man takes on a debt. The '
              'books are heavy and the table is empty, and nobody sitting at '
              'it would step in front of anything for him.',
          family: 30,
          commission: 50,
          cops: 50,
          cash: 70,
        );
    }
  }
}
