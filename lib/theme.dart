import 'package:flutter/material.dart';

/// Single source of truth for colour, type and layout proportions.
///
/// Type is JetBrains Mono, bundled as an asset (see pubspec `flutter.fonts`)
/// rather than fetched at runtime, so iOS and Android render identically and
/// there is no fallback flash on first paint.
///
/// Geometry is taken from docs/reference.png; the palette is ours. In the
/// reference the body is light tan and the portrait is *darker* than it. Here
/// those roles are inverted — dark body, portrait lighter — while every
/// proportion is kept.
class GameColors {
  const GameColors._();

  /// Page background — near-black, warmed towards brown.
  static const Color background = Color(0xFF15100C);

  /// Top meter bar and bottom status bar. One colour, as in the reference.
  static const Color bar = Color(0xFF0B0806);

  /// The portrait square. Flat tan-olive, no stroke, lighter than
  /// [background] so it reads as the visual centre.
  static const Color portrait = Color(0xFF8A7F5C);

  /// Heavy near-black shapes making up the character art.
  static const Color art = Color(0xFF14110D);

  /// Cream highlight inside the art — the face.
  static const Color artHighlight = Color(0xFFE8DCC0);

  /// Portrait colours once the run is over: no highlight, muted square.
  static const Color portraitDead = Color(0xFF4E4834);
  static const Color artDead = Color(0xFF1A1712);

  /// Name label sitting on the portrait, so it reads dark on light.
  static const Color nameOnPortrait = Color(0xFF1F1A12);

  /// Empty status square: a step up from the bar, as in the reference.
  static const Color statusSquare = Color(0xFF241C16);

  /// A blood pip still filled. Muted oxblood — the one hue outside the
  /// brown/cream/gold palette, kept desaturated so it never competes with
  /// the accent.
  static const Color bloodPip = Color(0xFF8C4A3A);

  /// Meter icons, at full brightness. Retained for anything that wants a
  /// plain cream glyph; the meter row itself now fills rather than dims.
  static const Color icon = Color(0xFFF2E7C4);

  /// The unfilled part of a meter icon — a dim ghost of the same silhouette,
  /// so the shape reads at 0 as clearly as at 100.
  ///
  /// Sits a little above [bar] and well below any fill colour: it must be
  /// findable on the dark bar without ever competing with the gold.
  static const Color iconGhost = Color(0xFF3E362B);

  /// A meter icon's fill inside the safe band. Same gold as [accent] —
  /// deliberately the same hue, because gold means *healthy* in the meter
  /// row and gold means *live* everywhere else.
  static const Color meterFill = accent;

  /// A meter icon's fill at either bound.
  ///
  /// Cold and drained rather than red: oxblood is spoken for by the blood
  /// pips, and a red/gold pairing would teach that gold-at-100 is good — the
  /// one thing that must not be true when both bounds are lethal.
  static const Color meterPale = Color(0xFFCBC7BC);

  /// The swipe-preview mark.
  ///
  /// Deliberately a neutral bright cream and not one of the two colours that
  /// already carry a verdict: gold means healthy, [meterPale] means dying.
  /// The mark says *this meter moves* and must not hint which way.
  static const Color previewMark = Color(0xFFEDE3D0);

  /// Gold-amber accent. Used sparingly — highlights, not fills.
  static const Color accent = Color(0xFFD9A441);

  /// Primary reading colour, for card text on the dark body.
  static const Color cream = Color(0xFFEDE3D0);

  /// Cream stepped back for secondary labels.
  static const Color creamDim = Color(0xFF9C917C);
}

/// Proportions measured from docs/reference.png (content area 244x435).
class GameLayout {
  const GameLayout._();

  /// Top meter bar: 72/435 of the reference.
  static const double meterBarFraction = 0.16;

  /// Bottom status bar: 55/435.
  static const double statusBarFraction = 0.13;

  /// Portrait square width: 200/244 of the content width.
  static const double portraitWidthFraction = 0.82;

  /// Gap above the card text, as a fraction of total height.
  static const double textTopGapFraction = 0.045;

  /// Horizontal padding for the card text block.
  static const double textSidePadding = 22;

  /// Status squares: 20x16 on a 244-wide reference, 16px apart, centred as a
  /// group rather than spread evenly. Blood pips reuse this row but are drawn
  /// smaller — blood sits below everything else in the hierarchy.
  static const int statusSquareCount = 4;
  static const double statusSquareSize = 20;
  static const double statusSquareGap = 15;

  /// Blood pips: same count and rhythm as the reference's bottom row, at a
  /// smaller size so the row reads as subordinate to the portrait above it.
  static const int bloodPipCount = 4;
  static const double bloodPipSize = 12;
  static const double bloodPipGap = 9;
}

class GameText {
  const GameText._();

  static const String _monoFamily = 'JetBrainsMono';

  /// Only reached if the bundled asset is somehow unavailable.
  static const List<String> _monoFallback = <String>[
    'monospace',
    'Courier New',
    'Courier',
  ];

  static const TextStyle _base = TextStyle(
    fontFamily: _monoFamily,
    fontFamilyFallback: _monoFallback,
    color: GameColors.cream,
    height: 1.5,
  );

  /// Body copy in the card-text region: cream, centred, on the dark body.
  static final TextStyle card = _base.copyWith(
    fontSize: 13,
    letterSpacing: 0.2,
  );

  /// Name seated inside the bottom of the portrait square. Dark on light,
  /// matching the reference's treatment.
  static final TextStyle name = _base.copyWith(
    fontSize: 11,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w700,
    color: GameColors.nameOnPortrait,
  );

  /// Pending choice label revealed while dragging.
  static final TextStyle choice = _base.copyWith(
    fontSize: 15,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w700,
    color: GameColors.accent,
  );

  /// Run counter on the game-over screen.
  static final TextStyle runCounter = _base.copyWith(
    fontSize: 12,
    letterSpacing: 2.4,
    fontWeight: FontWeight.w700,
    color: GameColors.accent,
  );

  /// Small all-caps labels.
  static final TextStyle label = _base.copyWith(
    fontSize: 10,
    letterSpacing: 1.6,
    color: GameColors.creamDim,
  );
}
