/// Batch-level balance analysis.
///
/// Distinct from [CardValidator] on purpose. The validator asks whether a
/// deck is *well-formed* — a broken card is a crash, so it runs at load and
/// throws. Balance is an authoring property: a batch whose cash meter only
/// ever falls is perfectly well-formed and will parse, boot and play. It is
/// just a bad batch.
///
/// So this never runs in the app. It runs in the test suite, per batch file,
/// and fails the build with a printable report.
///
/// It exists because batch 1 shipped with a directional bias that nothing
/// caught: cash net −310 and cops net +233 across 100 cards, which made four
/// of the eight endings statistically unreachable. Every meter must be
/// pushed in both directions about equally, or the deck quietly becomes a
/// one-way street.
library;

import 'card.dart';

/// The four meters, in the order they are reported.
const List<String> kMeters = <String>['family', 'commission', 'cops', 'cash'];

/// Magnitude bands a single non-zero meter delta can fall into.
///
/// `13-14` is the deliberate gap between "ordinary" and "heavy": a delta
/// landing there is usually a 12 that drifted or a 15 that lost its nerve.
enum MagnitudeBand {
  minor('1-4', 1, 4),
  ordinary('5-12', 5, 12),
  gap('13-14', 13, 14),
  heavy('15-25', 15, 25),
  outsized('26+', 26, 1 << 30);

  const MagnitudeBand(this.label, this.min, this.max);

  final String label;
  final int min;
  final int max;

  static MagnitudeBand forDelta(int absDelta) {
    for (final MagnitudeBand b in MagnitudeBand.values) {
      if (absDelta >= b.min && absDelta <= b.max) return b;
    }
    return MagnitudeBand.outsized;
  }
}

/// Thresholds a batch must satisfy to ship.
class BalanceLimits {
  const BalanceLimits({
    this.maxAbsNet = 50,
    this.minOrdinaryShare = 0.60,
    this.maxAbsViceNet = 30,
  });

  /// Largest tolerable net sum for one meter across a batch. Beyond this the
  /// meter has a directional bias and one of its two endings starts dying.
  final int maxAbsNet;

  /// Smallest tolerable share of non-zero deltas in the 5–12 band.
  final double minOrdinaryShare;

  /// Largest tolerable net sum contributed *by vice cards alone* to one
  /// meter.
  ///
  /// A vice pushes a meter the same way whichever way the player swipes, so
  /// its contribution is unavoidable rather than chosen. Ten vices all
  /// raising cops by ten would add two hundred to that meter no matter how
  /// the player played, which is the directional bias this file exists to
  /// stop, arriving through the one door left open for it. So vices must be
  /// paired against each other: for every card that makes heat unavoidable,
  /// one that makes cooling it unavoidable and expensive.
  final int maxAbsViceNet;

  static const BalanceLimits standard = BalanceLimits();
}

class BalanceReport {
  BalanceReport({
    required this.label,
    required this.cardCount,
    required this.nets,
    required this.raises,
    required this.lowers,
    required this.bands,
    required this.inertSides,
    required this.garnishSides,
    required this.viceCount,
    required this.viceNets,
    required this.limits,
  });

  final String label;
  final int cardCount;

  /// Sum of every delta for each meter. Near zero is the goal.
  final Map<String, int> nets;
  final Map<String, int> raises;
  final Map<String, int> lowers;
  final Map<MagnitudeBand, int> bands;

  /// Choice-sides that move no meter at all. A swipe that does nothing is
  /// not a decision.
  final int inertSides;

  /// Choice-sides whose largest meter movement is in the 1-4 band and which
  /// cost no blood — a side the player cannot see happen.
  ///
  /// There are no numbers on screen: a meter is an icon's opacity across a
  /// 0-100 range, and a 3-point move does not read as a change. So this is the
  /// inert side one step politer, and docs/content-prompt.md forbids it from
  /// batch 7 on.
  ///
  /// **Reported, never failed on.** Batches 1-4 carry eight, five, four and six
  /// of these, and re-pointing shipped batches is a decision somebody takes on
  /// purpose rather than something a new check forces at the moment it lands.
  final int garnishSides;

  /// Cards declaring `vice: true` — the ones that deny the pull-back.
  final int viceCount;

  /// What the vices alone contribute to each meter, whichever way the player
  /// swipes. Near zero means they are paired against each other.
  final Map<String, int> viceNets;

  final BalanceLimits limits;

  int get totalDeltas =>
      bands.values.fold(0, (int sum, int count) => sum + count);

  double share(MagnitudeBand band) =>
      totalDeltas == 0 ? 0 : (bands[band] ?? 0) / totalDeltas;

  /// Empty when the batch is shippable.
  List<String> get violations {
    final List<String> out = <String>[];
    for (final String meter in kMeters) {
      final int net = nets[meter] ?? 0;
      if (net.abs() > limits.maxAbsNet) {
        out.add(
          '$meter has a directional bias: net ${_signed(net)} across '
          '$cardCount cards, over the ${limits.maxAbsNet} limit. '
          'Whichever end this drifts toward becomes the common death and '
          'the other end becomes unreachable.',
        );
      }
    }
    final double ordinary = share(MagnitudeBand.ordinary);
    if (ordinary < limits.minOrdinaryShare) {
      out.add(
        'only ${_pct(ordinary)} of deltas are in the 5-12 band, under '
        'the ${_pct(limits.minOrdinaryShare)} floor. The batch is either '
        'hedging with 1-4 garnish or swinging too hard.',
      );
    }
    if ((bands[MagnitudeBand.outsized] ?? 0) > 0) {
      out.add(
        '${bands[MagnitudeBand.outsized]} delta(s) above 25, which is '
        'past the heaviest card the brief allows.',
      );
    }
    if (inertSides > 0) {
      out.add('$inertSides choice-side(s) move no meter at all.');
    }
    for (final String meter in kMeters) {
      final int net = viceNets[meter] ?? 0;
      if (net.abs() > limits.maxAbsViceNet) {
        out.add(
          'the vices lean on $meter: net ${_signed(net)} across '
          '$viceCount vice card(s), over the ${limits.maxAbsViceNet} limit. '
          'A vice moves its meter whichever way the player swipes, so an '
          'unpaired set of them is a one-way street with no swipe out of '
          'it. Pair each vice with one that makes the opposite unavoidable.',
        );
      }
    }
    return out;
  }

  static String _signed(int v) => v >= 0 ? '+$v' : '$v';
  static String _pct(double v) => '${(v * 100).toStringAsFixed(1)}%';

  @override
  String toString() {
    final StringBuffer b = StringBuffer()
      ..writeln(
        'balance: $label  ($cardCount cards, $totalDeltas non-zero '
        'deltas across ${cardCount * 2} sides)',
      );
    for (final String meter in kMeters) {
      b.writeln(
        '  ${meter.padRight(11)} net=${_signed(nets[meter] ?? 0).padLeft(5)}'
        '   raises=${(raises[meter] ?? 0).toString().padLeft(3)}'
        '   lowers=${(lowers[meter] ?? 0).toString().padLeft(3)}',
      );
    }
    if (viceCount > 0) {
      b.writeln(
        '  vices       ${viceCount.toString().padLeft(4)}'
        '   net ${kMeters.map((String m) => '$m ${_signed(viceNets[m] ?? 0)}').join('  ')}',
      );
    }
    b.writeln(
      '  garnish     ${garnishSides.toString().padLeft(4)}'
      '   sides whose largest move is 1-4 and cost no blood '
      '(reported, not failed on)',
    );
    for (final MagnitudeBand band in MagnitudeBand.values) {
      final int n = bands[band] ?? 0;
      if (n == 0 && band == MagnitudeBand.outsized) continue;
      b.writeln(
        '  ${band.label.padRight(11)} ${n.toString().padLeft(4)}'
        '   ${_pct(share(band)).padLeft(6)}',
      );
    }
    return b.toString();
  }
}

class DeckBalance {
  const DeckBalance._();

  static BalanceReport analyse(
    List<GameCard> cards, {
    String label = 'deck',
    BalanceLimits limits = BalanceLimits.standard,
  }) {
    final Map<String, int> nets = <String, int>{
      for (final String m in kMeters) m: 0,
    };
    final Map<String, int> raises = <String, int>{
      for (final String m in kMeters) m: 0,
    };
    final Map<String, int> lowers = <String, int>{
      for (final String m in kMeters) m: 0,
    };
    final Map<MagnitudeBand, int> bands = <MagnitudeBand, int>{
      for (final MagnitudeBand b in MagnitudeBand.values) b: 0,
    };
    int inert = 0;
    int garnish = 0;
    int vices = 0;
    final Map<String, int> viceNets = <String, int>{
      for (final String m in kMeters) m: 0,
    };

    for (final GameCard card in cards) {
      if (card.vice) vices++;
      for (final CardChoice choice in <CardChoice>[card.left, card.right]) {
        // Blood is excluded throughout: it only ever drains, so it has a
        // deliberate one-way bias and would poison every figure here.
        final Map<String, int> deltas = <String, int>{
          'family': choice.effects.family,
          'commission': choice.effects.commission,
          'cops': choice.effects.cops,
          'cash': choice.effects.cash,
        };
        int moved = 0;
        int largest = 0;
        deltas.forEach((String meter, int v) {
          if (v.abs() > largest) largest = v.abs();
          nets[meter] = nets[meter]! + v;
          if (card.vice) viceNets[meter] = viceNets[meter]! + v;
          if (v > 0) raises[meter] = raises[meter]! + 1;
          if (v < 0) lowers[meter] = lowers[meter]! + 1;
          if (v != 0) {
            moved++;
            final MagnitudeBand band = MagnitudeBand.forDelta(v.abs());
            bands[band] = bands[band]! + 1;
          }
        });
        if (moved == 0) inert++;
        if (moved > 0 && largest <= 4 && choice.effects.blood == 0) garnish++;
      }
    }

    return BalanceReport(
      label: label,
      cardCount: cards.length,
      nets: nets,
      raises: raises,
      lowers: lowers,
      bands: bands,
      inertSides: inert,
      garnishSides: garnish,
      viceCount: vices,
      viceNets: viceNets,
      limits: limits,
    );
  }
}
