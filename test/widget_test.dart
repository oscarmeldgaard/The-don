// Shell, swipe and game-over behaviour:  flutter test

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/art.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';
import 'package:mafia_reigns/game_state.dart';
import 'package:mafia_reigns/heir.dart';
import 'package:mafia_reigns/main.dart';
import 'package:mafia_reigns/score.dart';
import 'package:mafia_reigns/swipe_card.dart';
import 'package:mafia_reigns/theme.dart';

List<GameCard> _realDeck() => CardRepository.parseDeck(
      File('assets/cards/core.json').readAsStringSync(),
      throwOnInvalid: true,
    );

final EndingSet _endings = EndingsRepository.parse(
  File('assets/cards/endings.json').readAsStringSync(),
  throwOnInvalid: true,
);

GameState _state({List<GameCard>? deck, Random? random}) => GameState(
      deck: deck ?? _realDeck(),
      endings: _endings,
      random: random,
    );

/// A card whose right side moves each meter by the given amount.
GameCard _meterCard({
  required int family,
  required int commission,
  required int cops,
  required int cash,
}) =>
    GameCard(
      id: 'meters',
      speaker: 'METER SPEAKER',
      text: 'Meter card text.',
      left: const CardChoice(
        label: 'LEFT',
        effects: CardEffects(
          family: 0,
          commission: 0,
          cops: 0,
          cash: 0,
          blood: 0,
        ),
        setFlags: <String>[],
      ),
      right: CardChoice(
        label: 'RIGHT',
        effects: CardEffects(
          family: family,
          commission: commission,
          cops: cops,
          cash: cash,
          blood: 0,
        ),
        setFlags: const <String>[],
      ),
      requires: const CardRequires(
        flags: <String>[],
        excludesFlags: <String>[],
      ),
      weight: 1,
      once: false,
    );

/// A card whose right side costs [blood] and touches no meter.
GameCard _bloodCard(int blood) => GameCard(
      id: 'blood',
      speaker: 'BLOOD SPEAKER',
      text: 'Blood card text.',
      left: const CardChoice(
        label: 'LEFT',
        effects: CardEffects(
          family: 0,
          commission: 0,
          cops: 0,
          cash: 0,
          blood: 0,
        ),
        setFlags: <String>[],
      ),
      right: CardChoice(
        label: 'RIGHT',
        effects: CardEffects(
          family: 0,
          commission: 0,
          cops: 0,
          cash: 0,
          blood: blood,
        ),
        setFlags: const <String>[],
      ),
      requires: const CardRequires(
        flags: <String>[],
        excludesFlags: <String>[],
      ),
      weight: 1,
      once: false,
    );

/// A card whose right side is fatal to [meter]; left side is harmless.
GameCard _fatalCard() => GameCard(
      id: 'fatal',
      speaker: 'FATAL SPEAKER',
      text: 'Fatal card text.',
      left: const CardChoice(
        label: 'LEFT',
        effects: CardEffects(
          family: 0,
          commission: 0,
          cops: 0,
          cash: 0,
          blood: 0,
        ),
        setFlags: <String>[],
      ),
      right: const CardChoice(
        label: 'RIGHT',
        effects: CardEffects(
          family: -50,
          commission: 0,
          cops: 0,
          cash: 0,
          blood: 0,
        ),
        setFlags: <String>[],
      ),
      requires: const CardRequires(
        flags: <String>[],
        excludesFlags: <String>[],
      ),
      weight: 1,
      once: false,
    );

Future<void> _pumpGame(WidgetTester tester, GameState state) =>
    tester.pumpWidget(MaterialApp(home: GameScreen(state: state)));

void main() {
  testWidgets('renders the current card speaker and text', (
    WidgetTester tester,
  ) async {
    final GameCard only = _realDeck().first;
    final GameState state = _state(deck: <GameCard>[only]);

    await _pumpGame(tester, state);

    expect(find.text(only.speaker), findsOneWidget);
    expect(find.text(only.text), findsOneWidget);
  });

  testWidgets('dragging past the threshold commits the right choice', (
    WidgetTester tester,
  ) async {
    final GameState state = _state(random: Random(3));
    await _pumpGame(tester, state);

    final GameCard before = state.current;
    final int expectedFamily =
        (50 + before.right.effects.family).clamp(0, 100);

    await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(state.family, expectedFamily);
    expect(state.current.id, isNot(before.id));
  });

  testWidgets('dragging past the threshold leftwards commits the left choice', (
    WidgetTester tester,
  ) async {
    final GameState state = _state(random: Random(11));
    await _pumpGame(tester, state);

    final GameCard before = state.current;
    final int expectedCash = (50 + before.left.effects.cash).clamp(0, 100);

    await tester.drag(find.byType(CardSwiper), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(state.cash, expectedCash);
    expect(state.current.id, isNot(before.id));
  });

  testWidgets('releasing short of the threshold changes nothing', (
    WidgetTester tester,
  ) async {
    final GameState state = _state(random: Random(5));
    await _pumpGame(tester, state);

    final GameCard before = state.current;

    await tester.drag(find.byType(CardSwiper), const Offset(12, 0));
    await tester.pumpAndSettle();

    expect(state.current.id, before.id);
    expect(state.family, 50);
  });

  testWidgets('the pending choice label appears only past the threshold', (
    WidgetTester tester,
  ) async {
    final GameCard only = _realDeck().first;
    final GameState state = _state(deck: <GameCard>[only]);
    await _pumpGame(tester, state);

    expect(find.text(only.right.label), findsNothing);

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(CardSwiper)),
    );
    await gesture.moveBy(const Offset(500, 0));
    await tester.pump();

    expect(find.text(only.right.label), findsOneWidget);

    // Present in the tree is not enough: an earlier version rode the label
    // along inside the card's transform, which pushed it off-screen at
    // exactly the offset that was supposed to reveal it.
    final Rect labelRect = tester.getRect(find.text(only.right.label));
    final Size screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(labelRect.left, greaterThanOrEqualTo(0));
    expect(labelRect.right, lessThanOrEqualTo(screen.width));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  group('meter row', () {
    testWidgets('renders four icons carrying their own meter value', (
      WidgetTester tester,
    ) async {
      // A card that drives the four meters to different distances from the
      // midpoint, so each icon should end up rendered differently.
      final GameCard card = _meterCard(
        family: -50,
        commission: -25,
        cops: 40,
        cash: 50,
      );
      final GameState state = _state(deck: <GameCard>[card]);
      await _pumpGame(tester, state);

      await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
      await tester.pumpAndSettle();

      // Four painters, in meter order, each handed its own meter.
      final List<MeterIconPainter> painters = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((CustomPaint p) => p.painter)
          .whereType<MeterIconPainter>()
          .toList();

      expect(painters, hasLength(4), reason: 'four meter icons');
      expect(painters[0].icon, MeterIcon.family);
      expect(painters[0].value, state.family);
      expect(painters[1].icon, MeterIcon.commission);
      expect(painters[1].value, state.commission);
      expect(painters[2].icon, MeterIcon.cops);
      expect(painters[2].value, state.cops);
      expect(painters[3].icon, MeterIcon.cash);
      expect(painters[3].value, state.cash);

      // The whole point: a meter at a bound is in the danger treatment and
      // one inside the safe band is not. cops sits at 90, which is genuinely
      // in the top band too — commission at 25 is the honest contrast.
      expect(state.cash, 100);
      expect(state.commission, 25);
      expect(MeterFill.edgeFor(state.cash), MeterEdge.top);
      expect(MeterFill.edgeFor(state.commission), MeterEdge.none);

      // And the two lethal bounds are treated alike: family is empty, cash is
      // full, and neither is the colour that means healthy.
      expect(state.family, 0);
      expect(MeterFill.edgeFor(state.family), MeterEdge.bottom);
      expect(MeterFill.colorFor(state.family), GameColors.meterPale);
      expect(MeterFill.colorFor(state.cash), GameColors.meterPale);
    });

    test('fill height is monotonic in the meter', () {
      // The one channel that says *where* the meter sits, so it must never
      // fold 0 and 100 together the way the old opacity ramp did.
      expect(MeterFill.fraction(0), closeTo(0.0, 0.001));
      expect(MeterFill.fraction(50), closeTo(0.5, 0.001));
      expect(MeterFill.fraction(100), closeTo(1.0, 0.001));
      expect(MeterFill.fraction(75), greaterThan(MeterFill.fraction(25)));
    });

    test('pallor is symmetric about the midpoint and zero in the safe band',
        () {
      // Gold across the middle.
      expect(MeterFill.pallor(50), closeTo(0.0, 0.001));
      expect(MeterFill.pallor(MeterFill.paleBand), closeTo(0.0, 0.001));
      expect(MeterFill.pallor(100 - MeterFill.paleBand), closeTo(0.0, 0.001));

      // Fully drained at both bounds — the reward colour is spent at either
      // end, so nothing in the row teaches that up is good.
      expect(MeterFill.pallor(0), closeTo(1.0, 0.001));
      expect(MeterFill.pallor(100), closeTo(1.0, 0.001));

      // Symmetric, and monotonic on the way out.
      expect(MeterFill.pallor(10), closeTo(MeterFill.pallor(90), 0.001));
      expect(MeterFill.pallor(95), greaterThan(MeterFill.pallor(80)));

      expect(MeterFill.colorFor(50), GameColors.meterFill);
      expect(MeterFill.colorFor(0), GameColors.meterPale);
      expect(MeterFill.colorFor(100), GameColors.meterPale);
    });

    test('the bracket names which wall, and fires at both', () {
      expect(MeterFill.edgeFor(50), MeterEdge.none);
      expect(MeterFill.edgeFor(MeterFill.lowBand + 1), MeterEdge.none);
      expect(MeterFill.edgeFor(99 - MeterFill.highBand), MeterEdge.none);

      expect(MeterFill.edgeFor(MeterFill.lowBand), MeterEdge.bottom);
      expect(MeterFill.edgeFor(0), MeterEdge.bottom);
      expect(MeterFill.edgeFor(100 - MeterFill.highBand), MeterEdge.top);
      expect(MeterFill.edgeFor(100), MeterEdge.top);
    });

    test('the empty bound is warned about earlier than the full one', () {
      // Running out is the quiet death, so it gets the longer runway. This is
      // the asymmetry the whole treatment exists for — if these ever match,
      // the bottom has lost its head start.
      expect(MeterFill.lowBand, greaterThan(MeterFill.highBand));
      expect(MeterFill.edgeFor(MeterFill.highBand + 1), MeterEdge.bottom);
      expect(MeterFill.edgeFor(100 - MeterFill.highBand - 1), MeterEdge.none);
    });

    test('bracket depth escalates continuously to each bound', () {
      // Binary would say *you are in trouble* and never *you are getting
      // closer*, which is the wrong instrument for a death you do not feel.
      expect(MeterFill.depth(50), closeTo(0.0, 0.001));
      expect(MeterFill.depth(MeterFill.lowBand), closeTo(0.0, 0.001));
      expect(MeterFill.depth(100 - MeterFill.highBand), closeTo(0.0, 0.001));

      expect(MeterFill.depth(0), closeTo(1.0, 0.001));
      expect(MeterFill.depth(100), closeTo(1.0, 0.001));

      // Monotonic on the way in, at both ends.
      expect(MeterFill.depth(5), greaterThan(MeterFill.depth(15)));
      expect(MeterFill.depth(97), greaterThan(MeterFill.depth(88)));
    });
  });

  group('swipe preview', () {
    test('the mark never encodes direction', () {
      // The load-bearing property of the whole mechanic. If a sign ever
      // reaches the mark, the player is told whether a choice is good news
      // and stops having to reason about where the meter sits.
      for (int magnitude = 1; magnitude <= 22; magnitude++) {
        expect(
          MeterPreview.sizeFor(-magnitude),
          MeterPreview.sizeFor(magnitude),
          reason: 'a fall of $magnitude must look like a rise of $magnitude',
        );
      }
    });

    test('a meter that does not move gets no mark', () {
      expect(MeterPreview.sizeFor(0), 0);
    });

    test('the mark grows with magnitude and caps', () {
      expect(
        MeterPreview.sizeFor(12),
        greaterThan(MeterPreview.sizeFor(4)),
      );
      expect(MeterPreview.sizeFor(1), MeterPreview.minSize);
      expect(MeterPreview.sizeFor(MeterPreview.maxDelta),
          MeterPreview.maxSize);
      // Deltas past the top of the scale cap rather than overflow: the deck
      // has a handful above 18 and they must not draw off the bar.
      expect(MeterPreview.sizeFor(22), MeterPreview.maxSize);
    });

    test('marks appear before the choice label and finish before commit', () {
      expect(MeterPreview.growth(0), 0);
      expect(MeterPreview.growth(MeterPreview.fadeStart), 0);
      expect(MeterPreview.growth(MeterPreview.fadeFull), 1);
      expect(MeterPreview.growth(1), 1);
      // Ordering against the swiper's label fade, so the player learns which
      // powers are in play before being told what the choice is called.
      expect(MeterPreview.fadeStart, lessThan(0.55));
      expect(MeterPreview.fadeFull, greaterThan(MeterPreview.fadeStart));
    });

    testWidgets('dragging marks the meters the choice moves, and no others', (
      WidgetTester tester,
    ) async {
      // Right side moves family and cash; commission and cops are untouched.
      final GameCard card = _meterCard(
        family: -12,
        commission: 0,
        cops: 0,
        cash: 6,
      );
      final GameState state = _state(deck: <GameCard>[card]);
      await _pumpGame(tester, state);

      // The marks are the only circles on screen, and they sit in meter
      // order. Round is load-bearing rather than decorative: at the small end
      // a square read as a rendering fault instead of a gauge.
      double markWidth(MeterIcon meter) {
        final Finder marks = find.byWidgetPredicate(
          (Widget w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).shape == BoxShape.circle &&
              (w.decoration as BoxDecoration).color ==
                  GameColors.previewMark,
        );
        expect(marks, findsNWidgets(MeterIcon.values.length));
        return tester
            .getSize(marks.at(MeterIcon.values.indexOf(meter)))
            .width;
      }

      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.byType(CardSwiper)),
      );
      await gesture.moveBy(const Offset(500, 0));
      await tester.pump();

      // Moved meters carry a mark; untouched ones carry none.
      expect(markWidth(MeterIcon.family), greaterThan(0));
      expect(markWidth(MeterIcon.cash), greaterThan(0));
      expect(markWidth(MeterIcon.commission), 0);
      expect(markWidth(MeterIcon.cops), 0);

      // Bigger swing, bigger mark — magnitude only, and family is falling
      // while cash is rising.
      expect(
        markWidth(MeterIcon.family),
        greaterThan(markWidth(MeterIcon.cash)),
      );

      // Releasing clears the bar.
      await gesture.up();
      await tester.pumpAndSettle();
      expect(markWidth(MeterIcon.family), 0);
    });
  });

  group('year counter', () {
    test('one card is one year, and it opens at year one', () {
      final GameState state = _state(deck: <GameCard>[_bloodCard(0)]);
      expect(state.year, 1);
      state.choose(SwipeDirection.left);
      expect(state.year, 2);
      state.choose(SwipeDirection.left);
      expect(state.year, 3);
    });

    test('the year restarts with the heir but the record does not', () async {
      final InMemoryScoreStore scores = InMemoryScoreStore();
      final GameState state = GameState(
        deck: <GameCard>[_fatalCard()],
        endings: _endings,
        scores: scores,
      );

      state.choose(SwipeDirection.right); // fatal
      expect(state.isOver, isTrue);
      final int reached = state.year;
      expect(state.bestYear, reached);
      expect(await scores.loadBestYear(), reached);

      state.restart();
      expect(state.year, 1, reason: 'the heir starts his own reign');
      expect(state.bestYear, reached, reason: 'the record is the players');
    });

    test('the record only ever climbs', () async {
      final InMemoryScoreStore scores = InMemoryScoreStore(99);
      final GameState state = GameState(
        deck: <GameCard>[_fatalCard()],
        endings: _endings,
        scores: scores,
        bestYear: 99,
      );

      state.choose(SwipeDirection.right); // dies in year 1
      expect(state.isOver, isTrue);
      expect(state.bestYear, 99, reason: 'a short reign must not lower it');
      expect(await scores.loadBestYear(), 99);
    });

    testWidgets('the year shows during a run and the record only once set', (
      WidgetTester tester,
    ) async {
      final GameState state = _state(deck: <GameCard>[_bloodCard(0)]);
      await _pumpGame(tester, state);

      expect(find.text('SEAT 1'), findsOneWidget);
      // Nothing to beat yet, and "BEST 0" would read as a score rather than
      // as an absence.
      expect(find.textContaining('BEST'), findsNothing);

      await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text('SEAT 2'), findsOneWidget);
    });
  });

  group('blood strip', () {
    int litPips(WidgetTester tester) => tester
        .widgetList<Container>(find.byType(Container))
        .where((Container c) => c.color == GameColors.bloodPip)
        .length;

    testWidgets('starts full and empties in stages', (
      WidgetTester tester,
    ) async {
      // 30 blood per swipe: full -> 70 -> 40 -> 10, i.e. 4 -> 3 -> 2 -> 1.
      final GameState state = _state(
        deck: <GameCard>[_bloodCard(30)],
      );
      await _pumpGame(tester, state);

      expect(litPips(tester), 4);

      for (final int expected in <int>[3, 2, 1]) {
        await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
        await tester.pumpAndSettle();
        expect(litPips(tester), expected, reason: 'blood ${state.blood}');
      }
    });

    testWidgets('flickers briefly when a swipe drains blood', (
      WidgetTester tester,
    ) async {
      final GameState state = _state(deck: <GameCard>[_bloodCard(10)]);
      await _pumpGame(tester, state);

      double stripOpacity() => tester
          .widgetList<Opacity>(find.byType(Opacity))
          .firstWhere((Opacity o) => o.child is Row)
          .opacity;

      expect(stripOpacity(), 1.0);

      await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
      // Resolve the swipe so the commit lands and the flicker starts.
      await tester.pump(const Duration(milliseconds: 300));

      // Sample across the flicker window rather than guessing one instant:
      // the curve is deliberately 1.0 at its start and end.
      double dimmest = 1.0;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 40));
        dimmest = min(dimmest, stripOpacity());
      }

      expect(
        dimmest,
        lessThan(0.9),
        reason: 'the strip should visibly dip while flickering',
      );

      await tester.pumpAndSettle();
      expect(stripOpacity(), 1.0, reason: 'flicker settles back to opaque');
    });

    testWidgets('does not flicker when a swipe costs no blood', (
      WidgetTester tester,
    ) async {
      final GameState state = _state(deck: <GameCard>[_bloodCard(0)]);
      await _pumpGame(tester, state);

      await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 60));

      final double opacity = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .firstWhere((Opacity o) => o.child is Row)
          .opacity;
      expect(opacity, 1.0);
      expect(state.blood, GameState.bloodMax);
    });
  });

  group('game over', () {
    testWidgets('a fatal swipe shows the ending text and run counter', (
      WidgetTester tester,
    ) async {
      final GameState state = _state(deck: <GameCard>[_fatalCard()]);
      await _pumpGame(tester, state);

      // Run counter is hidden while the run is live.
      expect(find.textContaining('RUN '), findsNothing);

      await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
      await tester.pumpAndSettle();

      final Ending ending = _endings.lookup(
        MeterKind.family,
        MeterBound.empty,
      );
      expect(find.text(ending.text), findsOneWidget);
      expect(find.text(ending.title), findsOneWidget);
      // The run counter now shares its line with the year the reign reached.
      expect(find.textContaining('RUN 1'), findsOneWidget);
      expect(find.textContaining('SEAT ${state.year}'), findsOneWidget);
      // A first death is always the longest reign so far.
      expect(find.text('YOUR LONGEST'), findsOneWidget);
      expect(find.text('TAP TO CONTINUE'), findsOneWidget);

      // The live card is gone: no swiper on the game-over screen.
      expect(find.byType(CardSwiper), findsNothing);
    });

    testWidgets('tapping hands over to the heir and resumes play', (
      WidgetTester tester,
    ) async {
      final GameState state = _state(deck: <GameCard>[_fatalCard()]);
      await _pumpGame(tester, state);

      await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(state.isOver, isTrue);

      // No blood spent, so the loved son inherits.
      final Heir heir = Inheritance.of(HeirKind.lovedSon);
      expect(find.text(heir.name), findsOneWidget);
      expect(find.text(heir.line), findsOneWidget);
      expect(find.textContaining('FAMILY ${heir.family}'), findsOneWidget);

      await tester.tap(find.text('TAP TO CONTINUE'));
      await tester.pumpAndSettle();

      expect(state.isOver, isFalse);
      expect(state.family, heir.family);
      expect(state.cash, heir.cash);
      expect(state.runCount, 2);
      expect(find.byType(CardSwiper), findsOneWidget);
      expect(find.text('FATAL SPEAKER'), findsOneWidget);
      // Heir details belong to the game-over screen only.
      expect(find.textContaining('RUN '), findsNothing);
      expect(find.text(heir.line), findsNothing);
    });

    testWidgets('the run counter climbs across runs', (
      WidgetTester tester,
    ) async {
      final GameState state = _state(deck: <GameCard>[_fatalCard()]);
      await _pumpGame(tester, state);

      for (int expectedRun = 1; expectedRun <= 3; expectedRun++) {
        // One swipe no longer guarantees death: the heir may start with more
        // family than the founder did.
        while (!state.isOver) {
          await tester.drag(find.byType(CardSwiper), const Offset(500, 0));
          await tester.pumpAndSettle();
        }

        expect(find.textContaining('RUN $expectedRun'), findsOneWidget);

        await tester.tap(find.text('TAP TO CONTINUE'));
        await tester.pumpAndSettle();
      }

      expect(state.runCount, 4);
    });
  });
}
