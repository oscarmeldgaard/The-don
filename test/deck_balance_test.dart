import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/deck_balance.dart';

/// Balance is checked **per batch**, not on the concatenated deck.
///
/// A 900-card deck could net to zero overall while batch 4 was a cash
/// bloodbath and batch 5 quietly cancelled it out. The player only ever sees
/// a slice, so each slice has to stand on its own.
void main() {
  group('deck balance', () {
    for (final String path in CardRepository.deckPaths) {
      test('$path has no directional bias', () {
        final List<GameCard> cards = CardRepository.parseDeck(
          File(path).readAsStringSync(),
          throwOnInvalid: true,
        );
        final BalanceReport report =
            DeckBalance.analyse(cards, label: path);

        // Printed on every run, pass or fail: the numbers are the point,
        // and a batch drifting toward a limit should be visible before it
        // crosses one.
        // ignore: avoid_print
        print('\n$report');

        expect(
          report.violations,
          isEmpty,
          reason: '\n${report.violations.map((String v) => '  - $v').join('\n')}\n\n'
              '$report',
        );
      });
    }

    test('reports a batch that only ever drains one meter', () {
      // A guard on the guard: if this stops failing, the check has stopped
      // checking.
      final List<GameCard> rigged = <GameCard>[
        for (int i = 0; i < 20; i++)
          GameCard.fromJson(<String, dynamic>{
            'id': 'rig_$i',
            'speaker': 'THE CLUB',
            'text': 'x',
            'left': <String, dynamic>{
              'label': 'A',
              'effects': <String, dynamic>{
                'family': 0, 'commission': 0, 'cops': 0, 'cash': -8, 'blood': 0,
              },
              'setFlags': <String>[],
            },
            'right': <String, dynamic>{
              'label': 'B',
              'effects': <String, dynamic>{
                'family': 0, 'commission': 0, 'cops': 0, 'cash': -6, 'blood': 0,
              },
              'setFlags': <String>[],
            },
            'requires': <String, dynamic>{
              'flags': <String>[], 'excludesFlags': <String>[],
            },
            'weight': 1,
            'once': false,
          }),
      ];

      final BalanceReport report = DeckBalance.analyse(rigged, label: 'rigged');
      expect(report.nets['cash'], -280);
      expect(
        report.violations.any((String v) => v.startsWith('cash has a')),
        isTrue,
      );
    });

    test('flags a choice-side that moves nothing', () {
      final List<GameCard> inert = <GameCard>[
        GameCard.fromJson(<String, dynamic>{
          'id': 'inert_1',
          'speaker': 'THE CLUB',
          'text': 'x',
          'left': <String, dynamic>{
            'label': 'A',
            'effects': <String, dynamic>{
              'family': 0, 'commission': 0, 'cops': 0, 'cash': 0, 'blood': 9,
            },
            'setFlags': <String>[],
          },
          'right': <String, dynamic>{
            'label': 'B',
            'effects': <String, dynamic>{
              'family': 6, 'commission': 0, 'cops': -7, 'cash': 0, 'blood': 0,
            },
            'setFlags': <String>[],
          },
          'requires': <String, dynamic>{
            'flags': <String>[], 'excludesFlags': <String>[],
          },
          'weight': 1,
          'once': false,
        }),
      ];

      final BalanceReport report = DeckBalance.analyse(inert, label: 'inert');
      expect(report.inertSides, 1);
      expect(
        report.violations.any((String v) => v.contains('move no meter')),
        isTrue,
      );
    });
  });
}
