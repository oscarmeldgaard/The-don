import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'art.dart';
import 'card.dart';
import 'card_repository.dart';
import 'ending.dart';
import 'endings_repository.dart';
import 'game_state.dart';
import 'heir.dart';
import 'legacy.dart';
import 'playtest.dart';
import 'score.dart';
import 'swipe_card.dart';
import 'theme.dart';

/// The only animation in the game-over transition, per spec: a plain fade.
const Duration _kFadeDuration = Duration(milliseconds: 260);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Both validate as they parse; in debug either one throws here, before the
  // first frame, naming what is wrong.
  // Playtest hooks, read off the URL. Both off unless a query parameter
  // switches them on; see lib/playtest.dart.
  final PlaytestConfig playtest = PlaytestConfig.fromUri(Uri.base);

  final List<GameCard> deck = await CardRepository.loadDeck(rootBundle);
  final EndingSet endings = await EndingsRepository.loadFromBundle(rootBundle);

  // Two things are read back from disk and nothing else. The legacy is who
  // the last generation crossed and who it owed; the record is the longest
  // reign the *player* has managed, which belongs to them rather than to any
  // character. Meters, blood and ordinary flags all start fresh.
  const LegacyStore store = PrefsLegacyStore();
  const ScoreStore scores = PrefsScoreStore();
  final Legacy legacy = await store.load();
  final int bestYear = await scores.loadBestYear();

  runApp(
    MafiaReignsApp(
      deck: deck,
      endings: endings,
      legacy: legacy,
      store: store,
      scores: scores,
      bestYear: bestYear,
      random: playtest.random,
      trace: playtest.trace ? RunTrace(config: playtest) : null,
    ),
  );
}

class MafiaReignsApp extends StatefulWidget {
  const MafiaReignsApp({
    super.key,
    required this.deck,
    required this.endings,
    this.legacy = Legacy.empty,
    this.store,
    this.scores,
    this.bestYear = 0,
    this.random,
    this.trace,
  });

  final List<GameCard> deck;
  final EndingSet endings;
  final Legacy legacy;
  final LegacyStore? store;
  final ScoreStore? scores;

  /// The player's longest reign so far, read from disk before first frame.
  final int bestYear;

  /// Seedable for tests and for the seeded playtest run; null otherwise.
  final Random? random;

  /// Playtest recorder, or null. Never null-checked anywhere the player can
  /// see: the trace is written to the console and read after the session.
  final RunTrace? trace;

  @override
  State<MafiaReignsApp> createState() => _MafiaReignsAppState();
}

class _MafiaReignsAppState extends State<MafiaReignsApp> {
  late final GameState _state = GameState(
    deck: widget.deck,
    endings: widget.endings,
    legacy: widget.legacy,
    store: widget.store,
    scores: widget.scores,
    bestYear: widget.bestYear,
    random: widget.random,
    trace: widget.trace,
  );

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mafia Reigns',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: GameColors.background,
      ),
      home: GameScreen(state: _state),
    );
  }
}

/// Five stacked regions, in one of two states: a live run, or the ending.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.state});

  final GameState state;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// The live drag, shared between the swiper that produces it and the meter
  /// row that renders it. Held here because those two are siblings, and
  /// because routing a pointer-rate signal through [GameState] would rebuild
  /// the card, the portrait and the text on every frame of a drag.
  final ValueNotifier<SwipePreview?> _preview = ValueNotifier<SwipePreview?>(
    null,
  );

  @override
  void dispose() {
    _preview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameState state = widget.state;
    return Scaffold(
      backgroundColor: GameColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: state,
          builder: (BuildContext context, _) {
            final Ending? ending = state.ending;
            return AnimatedSwitcher(
              duration: _kFadeDuration,
              // Both views share the same five regions, so the default fade
              // is the whole transition.
              child: ending == null
                  ? _PlayView(
                      key: const ValueKey<String>('play'),
                      state: state,
                      preview: _preview,
                    )
                  : _GameOverView(
                      key: const ValueKey<String>('over'),
                      state: state,
                      ending: ending,
                    ),
            );
          },
        ),
      ),
    );
  }
}

/// A live run: the portrait is draggable.
class _PlayView extends StatelessWidget {
  const _PlayView({super.key, required this.state, required this.preview});

  final GameState state;
  final ValueNotifier<SwipePreview?> preview;

  @override
  Widget build(BuildContext context) {
    final GameCard card = state.current;
    return _Frame(
      meters: _MeterRow(state: state, preview: preview),
      text: _CardTextArea(text: card.text),
      // Deliberately unkeyed: the swiper must keep its State across cards,
      // since it is what resets the drag and runs the incoming card's
      // animation.
      portrait: CardSwiper(
        card: card,
        onChoice: state.choose,
        preview: preview,
        child: _PortraitArea(name: card.speaker),
      ),
      footer: _RunStrip(
        year: state.year,
        best: state.bestYear,
        blood: state.blood,
      ),
    );
  }
}

/// The run is over. Same five regions, no dragging; a tap anywhere restarts.
class _GameOverView extends StatelessWidget {
  const _GameOverView({super.key, required this.state, required this.ending});

  final GameState state;
  final Ending ending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: state.restart,
      child: _Frame(
        meters: _MeterRow(state: state),
        text: _CardTextArea(text: ending.text),
        // The one visual difference: the square and its art go muted.
        portrait: _PortraitArea(name: ending.title, dead: true),
        belowPortrait: state.heir == null
            ? null
            : _HeirBlock(heir: state.heir!),
        footer: _GameOverFooter(
          runCount: state.runCount,
          year: state.year,
          best: state.bestYear,
        ),
      ),
    );
  }
}

/// Shared five-region frame, proportioned from docs/reference.png. Both the
/// live run and the ending pour their content into the same slots.
class _Frame extends StatelessWidget {
  const _Frame({
    required this.meters,
    required this.text,
    required this.portrait,
    required this.footer,
    this.belowPortrait,
  });

  final Widget meters;
  final Widget text;
  final Widget portrait;
  final Widget footer;

  /// Optional block under the portrait. Sized to its content, so the
  /// portrait gives up height rather than anything overflowing.
  final Widget? belowPortrait;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = constraints.maxHeight;
        final double width = constraints.maxWidth;

        return Column(
          children: <Widget>[
            SizedBox(
              height: height * GameLayout.meterBarFraction,
              width: double.infinity,
              child: ColoredBox(color: GameColors.bar, child: meters),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * GameLayout.textTopGapFraction),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GameLayout.textSidePadding,
                    ),
                    child: text,
                  ),
                  // The portrait absorbs the leftover height and is capped at
                  // the reference's 82% of screen width, so it stays square
                  // and never overflows.
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: width * GameLayout.portraitWidthFraction,
                        ),
                        child: AspectRatio(aspectRatio: 1, child: portrait),
                      ),
                    ),
                  ),
                  if (belowPortrait != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        GameLayout.textSidePadding,
                        10,
                        GameLayout.textSidePadding,
                        4,
                      ),
                      child: belowPortrait,
                    ),
                ],
              ),
            ),
            SizedBox(
              height: height * GameLayout.statusBarFraction,
              width: double.infinity,
              child: ColoredBox(color: GameColors.bar, child: footer),
            ),
          ],
        );
      },
    );
  }
}

/// Region 1 — four icons on the dark bar. No numbers, no bars, no labels.
///
/// Each icon fills bottom-to-top with its meter, gold in the safe band and
/// cold bone as either bound approaches, with a hard rule against the wall it
/// is closest to. See [MeterFill] for why the fill alone is not enough.
class _MeterRow extends StatelessWidget {
  const _MeterRow({required this.state, this.preview});

  final GameState state;

  /// The live drag, or null on the game-over screen where there is none.
  final ValueNotifier<SwipePreview?>? preview;

  /// Space reserved beneath every icon for its preview mark, whether or not
  /// one is showing. Reserved rather than added on demand, so the icons do
  /// not jump up the bar the instant a finger moves.
  static const double _markGap = 6;

  @override
  Widget build(BuildContext context) {
    final Map<MeterIcon, int> values = <MeterIcon, int>{
      MeterIcon.family: state.family,
      MeterIcon.commission: state.commission,
      MeterIcon.cops: state.cops,
      MeterIcon.cash: state.cash,
    };

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Larger than the reference's 0.42: the painter reserves 15% gutters
        // top and bottom for the bracket's bar, so the silhouette itself
        // would otherwise have shrunk.
        final double iconSize = constraints.maxHeight * 0.54;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (final MapEntry<MeterIcon, int> entry in values.entries)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CustomPaint(
                      painter: MeterIconPainter(
                        icon: entry.key,
                        value: entry.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: _markGap),
                  _PreviewMark(meter: entry.key, preview: preview),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// The mark under one icon while a drag is in progress.
///
/// Size, and nothing else. See [MeterPreview] for why: no sign, no colour,
/// no number. Rebuilds on the notifier alone, so a drag repaints four small
/// squares rather than the whole screen.
class _PreviewMark extends StatelessWidget {
  const _PreviewMark({required this.meter, required this.preview});

  final MeterIcon meter;
  final ValueNotifier<SwipePreview?>? preview;

  static int _deltaFor(MeterIcon meter, CardEffects effects) => switch (meter) {
    MeterIcon.family => effects.family,
    MeterIcon.commission => effects.commission,
    MeterIcon.cops => effects.cops,
    MeterIcon.cash => effects.cash,
  };

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<SwipePreview?>? notifier = preview;
    if (notifier == null) {
      return const SizedBox(height: MeterPreview.maxSize);
    }
    return ValueListenableBuilder<SwipePreview?>(
      valueListenable: notifier,
      builder: (BuildContext context, SwipePreview? live, _) {
        double size = 0;
        double opacity = 0;
        if (live != null) {
          // Blood is deliberately absent: it has no icon on this bar, and
          // previewing a cost the player cannot see the level of would be
          // noise rather than information.
          final double full = MeterPreview.sizeFor(
            _deltaFor(meter, live.effects),
          );
          final double grown = MeterPreview.growth(live.progress);
          // Size carries magnitude; opacity carries how far the drag has
          // gone. Splitting them is what stops a barely-started drag drawing
          // a speck — the disc arrives already round and merely faint.
          size = full * MeterPreview.scaleFor(grown);
          opacity = grown;
        }
        return SizedBox(
          height: MeterPreview.maxSize,
          width: MeterPreview.maxSize,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: size,
                height: size,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: GameColors.previewMark,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Region 2 — centred cream card text between the meter row and the portrait.
class _CardTextArea extends StatelessWidget {
  const _CardTextArea({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: TextAlign.center, style: GameText.card);
  }
}

/// Regions 3 and 4 — the flat tan-olive square holding the character art,
/// with the name small and centred inside its bottom.
class _PortraitArea extends StatelessWidget {
  const _PortraitArea({required this.name, this.dead = false});

  /// Speaker name during a run; the ending title on the game-over screen.
  final String name;

  /// Game-over rendering: muted square, no face.
  final bool dead;

  @override
  Widget build(BuildContext context) {
    // Sizing lives in _Frame. This widget fills whatever square it is handed,
    // so the swipe threshold and the pending label are measured against the
    // frame the player can actually see.
    return ColoredBox(
      color: dead ? GameColors.portraitDead : GameColors.portrait,
      // A Column rather than a Stack: the name gets its own row, so the art
      // can never crowd it however the figure is drawn.
      child: Column(
        children: <Widget>[
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: PortraitArtPainter(dead: dead),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GameText.name,
            ),
          ),
        ],
      ),
    );
  }
}

/// Region 5 — the blood counter, as a short run of pips at the very bottom.
///
/// No number is shown, by design. The pips empty in stages, and the whole
/// row flickers briefly whenever a swipe costs blood, so the player registers
/// the price even when the stage boundary has not been crossed.
/// Region 5 during a run — the year at the left, blood centred, the record
/// at the right.
///
/// **Why here.** The meter bar is the one place the year must not go: four
/// icons that fill and cage themselves are already the busiest thing on
/// screen, and a number beside them would be read as a fifth meter. The
/// bottom strip is the natural home — it already carries the run's other
/// quiet counter, and putting the year beside blood groups *how long you have
/// lasted* with *what it has cost you*.
///
/// Blood stays exactly where it was, centred, because it was placed against
/// docs/reference.png. The year and the record are hung either side of it
/// rather than sharing a row with it, so nothing moved.
class _RunStrip extends StatelessWidget {
  const _RunStrip({
    required this.year,
    required this.best,
    required this.blood,
  });

  final int year;
  final int best;
  final int blood;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _BloodStrip(blood: blood)),
        Positioned(
          left: GameLayout.textSidePadding,
          top: 0,
          bottom: 0,
          child: Center(
            child: Text(
              'SEAT $year',
              style: GameText.label.copyWith(color: GameColors.cream),
            ),
          ),
        ),
        // Nothing to beat until a reign has actually ended, and an empty
        // record shown as "BEST 0" would read as a score of zero rather than
        // as an absence.
        if (best > 0)
          Positioned(
            right: GameLayout.textSidePadding,
            top: 0,
            bottom: 0,
            child: Center(child: Text('BEST $best', style: GameText.label)),
          ),
      ],
    );
  }
}

class _BloodStrip extends StatefulWidget {
  const _BloodStrip({required this.blood});

  final int blood;

  /// How many pips are lit for a given blood value.
  static int pipsFilled(int blood) {
    if (blood <= 0) return 0;
    final int perPip = (GameState.bloodMax / GameLayout.bloodPipCount).ceil();
    return (blood / perPip).ceil().clamp(0, GameLayout.bloodPipCount);
  }

  @override
  State<_BloodStrip> createState() => _BloodStripState();
}

class _BloodStripState extends State<_BloodStrip>
    with SingleTickerProviderStateMixin {
  static const Duration _flickerDuration = Duration(milliseconds: 460);

  late final AnimationController _flicker = AnimationController(
    vsync: this,
    duration: _flickerDuration,
  );

  @override
  void didUpdateWidget(_BloodStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only a drain flickers. Blood never rises during a run, but a restart
    // resets it, and that should not read as a cost.
    if (widget.blood < oldWidget.blood) {
      _flicker.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flicker.dispose();
    super.dispose();
  }

  /// A couple of decaying blinks, settling back to fully opaque.
  double _opacityAt(double t) {
    if (t <= 0 || t >= 1) return 1;
    return 1 - 0.8 * (1 - t) * sin(t * pi * 4).abs();
  }

  @override
  Widget build(BuildContext context) {
    final int lit = _BloodStrip.pipsFilled(widget.blood);

    return Center(
      child: AnimatedBuilder(
        animation: _flicker,
        builder: (BuildContext context, Widget? child) {
          return Opacity(opacity: _opacityAt(_flicker.value), child: child);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < GameLayout.bloodPipCount; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: GameLayout.bloodPipGap),
              Container(
                width: GameLayout.bloodPipSize,
                height: GameLayout.bloodPipSize,
                color: i < lit ? GameColors.bloodPip : GameColors.statusSquare,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Who takes over, shown on the game-over screen before the next run starts.
///
/// Name, one line on what he is to you, and what he opens with. The numbers
/// appear here and nowhere else: the meter row stays icons-only.
class _HeirBlock extends StatelessWidget {
  const _HeirBlock({required this.heir});

  final Heir heir;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(heir.name, style: GameText.runCounter),
        const SizedBox(height: 6),
        Text(heir.line, textAlign: TextAlign.center, style: GameText.label),
        const SizedBox(height: 8),
        Text(
          'FAMILY ${heir.family}   COMMISSION ${heir.commission}\n'
          'COPS ${heir.cops}   CASH ${heir.cash}',
          textAlign: TextAlign.center,
          style: GameText.label.copyWith(color: GameColors.cream),
        ),
      ],
    );
  }
}

/// Replaces the status strip on the game-over screen: run counter and the
/// tap hint. The run counter appears nowhere else.
class _GameOverFooter extends StatelessWidget {
  const _GameOverFooter({
    required this.runCount,
    required this.year,
    required this.best,
  });

  final int runCount;

  /// The year this reign reached. Already folded into [best] by the time this
  /// is built, so a new record shows the same number on both lines.
  final int year;
  final int best;

  @override
  Widget build(BuildContext context) {
    final bool record = year >= best;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('RUN $runCount   ·   SEAT $year', style: GameText.runCounter),
          const SizedBox(height: 6),
          Text(record ? 'YOUR LONGEST' : 'BEST $best', style: GameText.label),
          const SizedBox(height: 6),
          Text('TAP TO CONTINUE', style: GameText.label),
        ],
      ),
    );
  }
}
