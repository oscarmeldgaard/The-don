import 'package:flutter/material.dart';

import 'card.dart';
import 'game_state.dart';
import 'theme.dart';

/// What the meter row is told about a drag in progress.
///
/// Carries the pending side's [effects] and how far the drag has travelled.
/// The meter row renders **magnitude only** from this — never the sign. The
/// player is told which powers a choice puts in play and left to work out for
/// themselves whether that is good news, given where each meter is sitting.
@immutable
class SwipePreview {
  const SwipePreview({required this.effects, required this.progress});

  /// The effects of the side the drag is heading towards.
  final CardEffects effects;

  /// 0 at rest, 1 at the commit threshold.
  final double progress;

  @override
  bool operator ==(Object other) =>
      other is SwipePreview &&
      other.effects == effects &&
      other.progress == progress;

  @override
  int get hashCode => Object.hash(effects, progress);
}

/// Drag-to-choose wrapper around the portrait card.
///
/// Owns only presentation state (the current drag offset and the two
/// animations). It reports a committed direction upward and lets [GameState]
/// decide what that means.
class CardSwiper extends StatefulWidget {
  const CardSwiper({
    super.key,
    required this.card,
    required this.onChoice,
    required this.child,
    this.preview,
  });

  final GameCard card;
  final ValueChanged<SwipeDirection> onChoice;
  final Widget child;

  /// Written on every drag frame, cleared on release. The meter row listens.
  ///
  /// A notifier rather than a callback so a drag repaints four icons without
  /// rebuilding the card, the portrait and the text on every pointer move.
  final ValueNotifier<SwipePreview?>? preview;

  @override
  State<CardSwiper> createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> with TickerProviderStateMixin {
  // Swipe feel. The card is now 82% of screen width, so a fraction-of-card
  // threshold lands at roughly 70 logical pixels on a normal phone: short
  // enough to commit with a flick, long enough that a scroll-like nudge
  // springs back.
  //
  /// Fraction of the card's width the finger must travel to commit.
  static const double _thresholdFraction = 0.22;

  /// Rotation at a full card-width of travel, in radians (~9 degrees).
  /// Lower than before: the bigger card magnified the old tilt.
  static const double _maxRotation = 0.16;

  /// Drag progress at which the pending label starts appearing. Later than
  /// before, so the label reads as confirmation rather than clutter.
  static const double _labelFadeStart = 0.55;

  /// Exit is quick and entry slightly slower, so the new card feels like it
  /// arrives rather than snapping in.
  static const Duration _springBackDuration = Duration(milliseconds: 210);
  static const Duration _flyOffDuration = Duration(milliseconds: 170);
  static const Duration _enterDuration = Duration(milliseconds: 210);

  late final AnimationController _settle;
  late final AnimationController _enter;

  Animation<double>? _settleAnimation;

  /// Horizontal finger travel from rest, in logical pixels.
  double _dragX = 0;

  /// Width of the card, captured during layout; used for threshold and
  /// fly-off distance.
  double _cardWidth = 0;

  /// Set when a release has passed the threshold and the fly-off is running.
  SwipeDirection? _pendingCommit;

  @override
  void initState() {
    super.initState();
    _settle = AnimationController(vsync: this, duration: _springBackDuration)
      ..addListener(_onSettleTick)
      ..addStatusListener(_onSettleStatus);
    // Starts settled so the first card does not animate in from nothing.
    _enter = AnimationController(
      vsync: this,
      duration: _enterDuration,
      value: 1,
    );
  }

  @override
  void dispose() {
    // The notifier outlives this widget, so a swiper torn down mid-drag must
    // not leave its preview standing on the bar.
    widget.preview?.value = null;
    _settle
      ..removeListener(_onSettleTick)
      ..removeStatusListener(_onSettleStatus)
      ..dispose();
    _enter.dispose();
    super.dispose();
  }

  void _onSettleTick() {
    final Animation<double>? animation = _settleAnimation;
    if (animation == null) return;
    setState(() => _dragX = animation.value);
  }

  void _onSettleStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    final SwipeDirection? direction = _pendingCommit;
    if (direction == null) return; // Spring-back finished; nothing to commit.

    _pendingCommit = null;
    // Snap back to centre before the new card is shown, then fade it in.
    setState(() => _dragX = 0);
    widget.onChoice(direction);
    _enter.forward(from: 0);
  }

  bool get _isBusy => _settle.isAnimating;

  double get _threshold =>
      _cardWidth == 0 ? double.infinity : _cardWidth * _thresholdFraction;

  /// 0 at rest, 1 at the commit threshold.
  double get _progress =>
      _threshold.isFinite ? (_dragX.abs() / _threshold).clamp(0.0, 1.0) : 0.0;

  /// Publishes the pending side and drag distance for the meter row.
  ///
  /// Cleared to null the moment the drag stops mattering, so a released card
  /// never leaves a stale preview on the bar.
  void _publishPreview() {
    final ValueNotifier<SwipePreview?>? preview = widget.preview;
    if (preview == null) return;
    if (_dragX == 0) {
      preview.value = null;
      return;
    }
    preview.value = SwipePreview(
      effects: (_dragX < 0 ? widget.card.left : widget.card.right).effects,
      progress: _progress,
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isBusy) return;
    setState(() => _dragX += details.delta.dx);
    _publishPreview();
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isBusy) return;

    // The preview has done its job by the time the finger lifts: whichever
    // way this resolves, the answer is about to be visible in the meters.
    widget.preview?.value = null;

    if (_dragX.abs() >= _threshold) {
      _pendingCommit = _dragX < 0 ? SwipeDirection.left : SwipeDirection.right;
      // Carry the card clear of the screen edge before swapping it.
      _animateTo(
        _dragX.sign * _cardWidth * 2,
        duration: _flyOffDuration,
        curve: Curves.easeIn,
      );
    } else {
      _pendingCommit = null;
      _animateTo(0, duration: _springBackDuration, curve: Curves.easeOutBack);
    }
  }

  void _animateTo(
    double target, {
    required Duration duration,
    required Curve curve,
  }) {
    _settleAnimation = Tween<double>(
      begin: _dragX,
      end: target,
    ).animate(CurvedAnimation(parent: _settle, curve: curve));
    _settle
      ..duration = duration
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _cardWidth = constraints.maxWidth;

        final double rotation = _cardWidth == 0
            ? 0
            : (_dragX / _cardWidth) * _maxRotation;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _enter,
                  builder: (BuildContext context, Widget? child) {
                    return Opacity(
                      opacity: _enter.value,
                      child: Transform.scale(
                        scale: 0.94 + (0.06 * _enter.value),
                        child: child,
                      ),
                    );
                  },
                  child: Transform.translate(
                    offset: Offset(_dragX, 0),
                    child: Transform.rotate(
                      angle: rotation,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
              // Anchored to the card's resting bounds, deliberately outside
              // the drag transform: riding along with the card would carry
              // the label off-screen exactly as it became relevant.
              Positioned.fill(child: _buildPendingLabel()),
            ],
          ),
        );
      },
    );
  }

  /// The label for whichever side the current drag is heading towards.
  Widget _buildPendingLabel() {
    if (_dragX == 0) return const SizedBox.shrink();

    final bool goingLeft = _dragX < 0;
    final String label = goingLeft
        ? widget.card.left.label
        : widget.card.right.label;

    final double opacity = _labelFadeStart >= 1
        ? 0
        : ((_progress - _labelFadeStart) / (1 - _labelFadeStart)).clamp(
            0.0,
            1.0,
          );

    if (opacity == 0) return const SizedBox.shrink();

    return IgnorePointer(
      child: Align(
        alignment: goingLeft ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Opacity(
            opacity: opacity,
            child: Text(label, style: GameText.choice),
          ),
        ),
      ),
    );
  }
}
