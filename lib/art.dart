import 'package:flutter/material.dart';

import 'theme.dart';

/// Drawn art. The meter icons are Material glyphs (see [MeterIconPainter]);
/// the character portrait below is still placeholder — flat single-colour
/// shapes in the reference's blocky style, meant to be replaced by real art.

enum MeterIcon { family, commission, cops, cash }

/// Which wall a meter is pressed against, if any.
enum MeterEdge { none, bottom, top }

/// How a meter icon is filled, coloured and warned about.
///
/// Replaced an opacity ramp that was brightest at 50 and dim at both bounds.
/// That was symmetric, which was right, but it made 0 and 100 render
/// identically — the player could see they were in trouble and not which
/// wall was coming. The fill fixes that and introduces the opposite problem:
/// a full gold icon reads as *good* to every instinct a player has, and here
/// 100 kills as fast as 0.
///
/// So three channels, and only the first is monotonic:
///
///   * **[fraction]** — height, 0 empty to 100 full. The only thing that says
///     where the meter sits and which way it is drifting.
///   * **[colorFor]** — gold inside [paleBand]..100-[paleBand], ramping to a
///     cold bone at either bound. The reward colour is spent at *both*
///     extremes, so nothing teaches that up is good.
///   * **[edgeFor]** / **[depth]** — a bracket closing on the threatened
///     edge. Built out of *area* rather than brightness, which is the whole
///     reason it exists: near 0 there is almost nothing lit, so an alarm made
///     of brightness has nowhere to put itself.
///
/// The bands are deliberately **asymmetric**. Running out is the quiet death
/// — a meter emptying is not noticed the way a meter filling is — so the
/// bottom band opens earlier ([lowBand]) and its bracket reaches roughly two
/// and a half times as far as the top's.
///
/// All of it is display-only. No meter value, threshold or balance figure
/// depends on anything here.
class MeterFill {
  const MeterFill._();

  /// Distance from a bound within which the fill is no longer pure gold.
  /// Roughly two heavy swipes.
  static const int paleBand = 25;

  /// Distance from the **empty** bound within which the bracket appears.
  static const int lowBand = 20;

  /// Distance from the **full** bound within which the bracket appears.
  /// Five points later than [lowBand]: a filling meter announces itself.
  static const int highBand = 15;

  /// Height of the fill, 0 at an empty meter and 1 at a full one.
  static double fraction(int value) => (value / 100.0).clamp(0.0, 1.0);

  /// 0 while the meter is safe, ramping to 1 at either bound.
  ///
  /// Symmetric by construction: it reads only the distance from the midpoint,
  /// never the sign.
  static double pallor(int value) {
    final double fromMiddle = (value - 50).abs() / 50.0;
    const double start = (50 - paleBand) / 50.0;
    if (fromMiddle <= start) return 0;
    return ((fromMiddle - start) / (1 - start)).clamp(0.0, 1.0);
  }

  /// Gold in the safe band, cold bone at either bound.
  static Color colorFor(int value) =>
      Color.lerp(GameColors.meterFill, GameColors.meterPale, pallor(value))!;

  /// Which wall the bracket closes on, or [MeterEdge.none].
  static MeterEdge edgeFor(int value) {
    if (value <= lowBand) return MeterEdge.bottom;
    if (value >= 100 - highBand) return MeterEdge.top;
    return MeterEdge.none;
  }

  /// How far into the danger band the meter has travelled: 0 at the outer
  /// edge of the band, 1 at the bound itself.
  ///
  /// This is what makes the alarm continuous rather than binary. A rule that
  /// merely switches on says *you are in trouble* and never *you are getting
  /// closer*, which is the wrong instrument for a death the player does not
  /// feel coming.
  static double depth(int value) {
    switch (edgeFor(value)) {
      case MeterEdge.bottom:
        return ((lowBand - value) / lowBand).clamp(0.0, 1.0);
      case MeterEdge.top:
        return ((value - (100 - highBand)) / highBand).clamp(0.0, 1.0);
      case MeterEdge.none:
        return 0;
    }
  }
}

/// How a drag-in-progress is previewed on the meter row.
///
/// One mark per affected meter, sized by **magnitude only**. It says *this
/// choice puts these powers in play, roughly this hard* and stops there — the
/// player is left to work out whether that is good news from where each meter
/// is currently sitting, which is the entire point of the mechanic.
///
/// Three rules, and breaking any of them gives the answer away:
///
///   * **no sign.** [sizeFor] takes an absolute value and there is no path
///     from a negative effect to a different mark.
///   * **no colour.** One neutral bright cream, [GameColors.previewMark] —
///     not the gold that means healthy and not the bone that means dying,
///     either of which would read as a verdict.
///   * **no number.** Size is deliberately coarse; nobody can read 7 versus 8
///     off a small disc, and they are not meant to.
///
/// **A disc, not a square.** The first build used a square, to rhyme with the
/// blood pips and the status row. It read badly: at the small end a square is
/// four hard corners of cream that look like a rendering fault rather than a
/// gauge, and the four of them in a row read as a second status strip. A disc
/// has no orientation to misread, stays legible as it shrinks, and is the one
/// round thing on a bar of rectangles — which is what makes it obviously a
/// *reading* rather than another piece of state.
class MeterPreview {
  const MeterPreview._();

  /// Deltas in the deck run 2..22, with the bulk between 4 and 12 and only
  /// five slots in the whole 900 above 18. The scale is fitted to that: 18
  /// tops it out, and the handful beyond simply cap.
  static const int minDelta = 1;
  static const int maxDelta = 18;

  /// Disc diameter in logical pixels, at the extremes of
  /// [minDelta]..[maxDelta].
  ///
  /// Raised from the first build's 4..11, which was too timid to read at arm's
  /// length on a phone. The floor matters more than the ceiling: the smallest
  /// possible mark still has to look deliberate.
  static const double minSize = 7;
  static const double maxSize = 16;

  /// Drag progress at which marks start appearing and reach full size.
  ///
  /// Both earlier than the choice label's 0.55, so the order a player meets
  /// them in is: which powers move, then how hard, then what the choice is
  /// called, then commit.
  static const double fadeStart = 0.10;
  static const double fadeFull = 0.72;

  /// How much of its full diameter a mark has when it first becomes visible.
  ///
  /// Not zero, deliberately. Growing from nothing means the first few frames
  /// of every drag draw a sub-pixel speck, which is exactly the smeared look
  /// the square version was criticised for. The disc fades in at [entryScale]
  /// already large enough to read as a circle.
  static const double entryScale = 0.6;

  /// Full size for a delta, ignoring drag progress. 0 when nothing moves.
  static double sizeFor(int delta) {
    final int magnitude = delta.abs();
    if (magnitude < minDelta) return 0;
    final double t = ((magnitude - minDelta) / (maxDelta - minDelta)).clamp(
      0.0,
      1.0,
    );
    return minSize + (maxSize - minSize) * t;
  }

  /// 0 before the marks appear, 1 once the drag has gone far enough.
  static double growth(double progress) =>
      ((progress - fadeStart) / (fadeFull - fadeStart)).clamp(0.0, 1.0);

  /// The fraction of [sizeFor] to actually draw, given [growth].
  static double scaleFor(double growth) =>
      entryScale + (1 - entryScale) * growth.clamp(0.0, 1.0);
}

/// Meter icons: a crew, a gavel, a badge and a bank.
///
/// **Set:** Material Design Icons, filled style, **Apache License 2.0**.
/// Attribution is appreciated by Google but explicitly not required, which is
/// why this set and not Font Awesome Free (CC BY 4.0) or game-icons.net
/// (CC BY 3.0, per author) — both would need a visible credit, and this game
/// deliberately has nowhere to put one. The glyphs ship inside Flutter's
/// bundled `MaterialIcons` font because pubspec sets `uses-material-design`,
/// so there is no new asset and no new dependency.
///
/// **The selection criterion was fill behaviour**, not how a glyph looks
/// standing still: the fill clips from the bottom, so a glyph whose lower half
/// is thin or broken into pieces reads as nothing at all at low values.
/// `table_restaurant` (three hairline legs) and `attach_money` (a thin stroke)
/// were rejected on exactly that, as was `handshake` — half-filled at 32px it
/// is an unreadable diagonal smear.
///
/// **Two of the four are chosen against that criterion, deliberately.**
/// `gavel` was measured as the worst fill shape of the twelve candidates: its
/// head is a disjoint diagonal over a separate base bar, so low values light
/// only the bar and mid values fill unevenly. It ships anyway because it is
/// instantly readable as *judgement*, and legibility of meaning was ranked
/// above smoothness of fill. `account_balance` moved from commission to cash
/// for the same reason — a bank is a plainer picture of money than a stack of
/// notes — and it happens to be one of the best fill shapes in the set, since
/// its plinth is a solid bar.
///
/// If the gavel ever reads badly in play, the fix is a different glyph, not a
/// change to the fill: the fill is shared by all four.
class MeterIconPainter extends CustomPainter {
  const MeterIconPainter({required this.icon, required this.value});

  final MeterIcon icon;

  /// The meter's current value, 0..100. Drives height, colour and the edge
  /// rule — see [MeterFill].
  final int value;

  /// Vertical share of the box given over to the gutters the bracket's bar
  /// sits in, split between top and bottom.
  ///
  /// The bar needs somewhere to live that is not on top of the silhouette, or
  /// it reads as part of the icon rather than as a wall closing in. The
  /// bracket's *arms* do reach into the icon area — that is the point of them.
  static const double _gutter = 0.15;

  /// Bar thickness and arm width, as a share of the box.
  static const double _armWidth = 0.07;

  /// How far the arms reach at the outer edge of the band, and how much
  /// further they travel by the bound. Bottom roughly 2.5× the top: the
  /// asymmetry is the whole point — see [MeterFill].
  ///
  /// The low base is deliberately not small. At 0.10 the arms were stubs at
  /// value 20 and the bracket read as a bare line, so *entering* the bottom
  /// band was silent — the wrong moment for silence, since that is the death
  /// the player does not feel coming. 0.16 gives the band entry an onset.
  static const double _lowReachBase = 0.16;
  static const double _lowReachGrowth = 0.48;
  static const double _highReachBase = 0.06;
  static const double _highReachGrowth = 0.20;

  /// Per-glyph shrink, applied about the centre of the icon area.
  ///
  /// The hand-drawn safe needed one because it ran the full width of its box
  /// and the bracket's arms crowded it. Material glyphs carry their own
  /// padding inside the em square, so all four sit at 1.0 — the hook stays
  /// because insetting the glyph is the sanctioned fix if a future icon
  /// crowds the arms. Never narrow the arms: the arms *are* the alarm.
  static double _glyphScale(MeterIcon icon) => 1.0;

  /// Which Material glyph stands for each meter.
  static IconData glyphFor(MeterIcon icon) => switch (icon) {
    MeterIcon.family => Icons.groups,
    MeterIcon.commission => Icons.gavel,
    MeterIcon.cops => Icons.local_police,
    MeterIcon.cash => Icons.account_balance,
  };

  /// Paints the glyph filling [box], in [color].
  ///
  /// A font glyph rather than a hand-rolled path, so the shape is the icon
  /// set's and not an approximation of it. Laid out per call: it is one
  /// single-character layout, done twice per icon and only when a meter
  /// actually changes, which is nothing next to a frame.
  void _drawGlyph(Canvas canvas, Rect box, Color color) {
    final IconData glyph = glyphFor(icon);
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(glyph.codePoint),
        style: TextStyle(
          fontFamily: glyph.fontFamily,
          package: glyph.fontPackage,
          fontSize: box.shortestSide,
          color: color,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(
        box.left + (box.width - painter.width) / 2,
        box.top + (box.height - painter.height) / 2,
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.shortestSide;
    final Offset origin = Offset((size.width - s) / 2, (size.height - s) / 2);

    // The silhouette is drawn in a unit box scaled to [inner], inset from the
    // top and bottom so the gutters stay clear.
    final double inner = s * (1 - 2 * _gutter);
    final double top = origin.dy + s * _gutter;
    final double left = origin.dx + (s - inner) / 2;

    final double scale = _glyphScale(icon);
    final double drawn = inner * scale;
    final Rect glyphBox = Rect.fromLTWH(
      left + (inner - drawn) / 2,
      top + (inner - drawn) / 2,
      drawn,
      drawn,
    );

    void drawSilhouette(Color color) => _drawGlyph(canvas, glyphBox, color);

    // 1. The whole shape, ghosted. Drawn at every value, so the icon is
    //    identifiable at 0 rather than being simply absent.
    drawSilhouette(GameColors.iconGhost);

    // 2. The same shape again, clipped to the filled height from the bottom.
    final double fraction = MeterFill.fraction(value);
    if (fraction > 0) {
      canvas.save();
      canvas.clipRect(
        Rect.fromLTRB(
          origin.dx,
          top + inner * (1 - fraction),
          origin.dx + s,
          top + inner,
        ),
      );
      drawSilhouette(MeterFill.colorFor(value));
      canvas.restore();
    }

    // 3. The bracket, if a bound is close: a bar against the threatened edge
    //    with arms reaching up (or down) the sides, further the deeper into
    //    the band the meter has gone. Full box width, so it reads as a limit
    //    closing in rather than as another part of the glyph.
    final MeterEdge edge = MeterFill.edgeFor(value);
    if (edge == MeterEdge.none) return;

    final bool low = edge == MeterEdge.bottom;
    final double arm = s * _armWidth;
    final double depth = MeterFill.depth(value);
    final double reach = low
        ? s * (_lowReachBase + _lowReachGrowth * depth)
        : s * (_highReachBase + _highReachGrowth * depth);

    final Paint alarm = Paint()
      ..color = GameColors.meterPale
      ..isAntiAlias = true;

    final double barY = low ? origin.dy + s - arm : origin.dy;
    canvas.drawRect(Rect.fromLTWH(origin.dx, barY, s, arm), alarm);

    final double armY = low ? origin.dy + s - reach : origin.dy;
    canvas.drawRect(Rect.fromLTWH(origin.dx, armY, arm, reach), alarm);
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + s - arm, armY, arm, reach),
      alarm,
    );
  }

  @override
  bool shouldRepaint(MeterIconPainter oldDelegate) =>
      oldDelegate.icon != icon || oldDelegate.value != value;
}

/// Placeholder character art: a blocky hatted figure, heavy black shapes with
/// a cream face, in the reference's style.
class PortraitArtPainter extends CustomPainter {
  const PortraitArtPainter({required this.dead});

  /// Game-over rendering: muted, no face highlight.
  final bool dead;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint body = Paint()
      ..color = dead ? GameColors.artDead : GameColors.art
      ..isAntiAlias = true;

    Rect r(double l, double t, double right, double b) =>
        Rect.fromLTRB(l * w, t * h, right * w, b * h);

    // Shoulders, neck, head.
    canvas.drawRect(r(0.16, 0.74, 0.84, 1.0), body);
    canvas.drawRect(r(0.43, 0.60, 0.57, 0.78), body);
    canvas.drawRect(r(0.30, 0.26, 0.70, 0.66), body);

    // Hat: brim then crown.
    canvas.drawRect(r(0.18, 0.22, 0.82, 0.30), body);
    canvas.drawRect(r(0.33, 0.06, 0.67, 0.24), body);

    if (dead) return;

    final Paint face = Paint()
      ..color = GameColors.artHighlight
      ..isAntiAlias = true;
    canvas.drawRect(r(0.36, 0.33, 0.64, 0.62), face);

    // Eyes, as two dark slots.
    canvas.drawRect(r(0.42, 0.42, 0.46, 0.50), body);
    canvas.drawRect(r(0.54, 0.42, 0.58, 0.50), body);
  }

  @override
  bool shouldRepaint(PortraitArtPainter oldDelegate) =>
      oldDelegate.dead != dead;
}
