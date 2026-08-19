// Command-line deck checks:  flutter test
//
// Two jobs. First, validate the deck that actually ships, read straight off
// disk. Second, prove the validator catches each class of mistake and names
// the offending card while doing it.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/card.dart';
import 'package:mafia_reigns/card_repository.dart';
import 'package:mafia_reigns/card_validator.dart';
import 'package:mafia_reigns/flags.dart';
import 'package:mafia_reigns/legacy.dart';

/// Nested maps must be typed `<String, dynamic>` to match what `jsonDecode`
/// produces; a bare literal infers a narrower type and would not be
/// representative of real decoded JSON.
Map<String, dynamic> _choice() => <String, dynamic>{
      'label': 'LABEL',
      'effects': <String, dynamic>{
        'family': 1,
        'commission': -1,
        'cops': 0,
        'cash': 2,
        'blood': 0,
      },
      // Must be a registered flag, or every card built here trips the
      // registry check.
      'setFlags': <dynamic>[GameFlags.docksTaken],
    };

Map<String, dynamic> _card(String id) => <String, dynamic>{
      'id': id,
      'speaker': 'A SPEAKER',
      'text': 'Some card text.',
      'left': _choice(),
      'right': _choice(),
      'requires': <String, dynamic>{
        'flags': <dynamic>[],
        'excludesFlags': <dynamic>[],
      },
      'weight': 5,
      'once': false,
    };

String _messages(List<CardIssue> issues) =>
    issues.map((CardIssue i) => i.toString()).join('\n');

List<GameCard> _deck() => CardRepository.parseDeck(
      File('assets/cards/core.json').readAsStringSync(),
      throwOnInvalid: true,
    );

Set<String> _settableByCards() => <String>{
      for (final GameCard card in _deck()) ...<String>[
        ...card.left.setFlags,
        ...card.right.setFlags,
      ],
    };

void main() {
  group('shipped core deck', () {
    late Object? decoded;

    setUpAll(() {
      final File file = File('assets/cards/core.json');
      expect(file.existsSync(), isTrue,
          reason: 'assets/cards/core.json is missing');
      decoded = jsonDecode(file.readAsStringSync());
    });

    test('passes validation', () {
      final List<CardIssue> issues = CardValidator.validateDeck(decoded);
      expect(issues, isEmpty, reason: '\n${_messages(issues)}');
    });

    test('contains 39 cards', () {
      expect(decoded, isA<List<dynamic>>());
      expect((decoded! as List<dynamic>).length, 39);
    });

    test('blood is never negative: it is a cost, not a gain', () {
      for (final Object? entry in decoded! as List<dynamic>) {
        final Map<String, dynamic> card = entry! as Map<String, dynamic>;
        for (final String side in <String>['left', 'right']) {
          final int blood = ((card[side]! as Map<String, dynamic>)['effects']!
              as Map<String, dynamic>)['blood'] as int;
          expect(
            blood,
            greaterThanOrEqualTo(0),
            reason: '${card['id']} $side',
          );
        }
      }
    });

    test('most cards cost no blood at all', () {
      final List<dynamic> deck = decoded! as List<dynamic>;
      int withBlood = 0;
      for (final Object? entry in deck) {
        final Map<String, dynamic> card = entry! as Map<String, dynamic>;
        final bool any = <String>['left', 'right'].any((String side) {
          return (((card[side]! as Map<String, dynamic>)['effects']!
                  as Map<String, dynamic>)['blood'] as int) >
              0;
        });
        if (any) withBlood++;
      }
      expect(
        withBlood,
        lessThan(deck.length - withBlood),
        reason: '$withBlood of ${deck.length} cards cost blood',
      );
    });

    test('parses into models, including the blood cost', () {
      final List<GameCard> deck = CardRepository.parseDeck(
        File('assets/cards/core.json').readAsStringSync(),
        throwOnInvalid: true,
      );
      expect(deck.length, 39);
      expect(deck.first.left.effects.blood, isA<int>());
      expect(deck.first.right.effects.blood, isA<int>());
    });

    test('every run flag is set by at least one card', () {
      // Inherited flags are excluded deliberately: no card sets them, they
      // are seeded from the persisted legacy.
      expect(
        GameFlags.runFlags.difference(_settableByCards()),
        isEmpty,
        reason: 'run flags that no card ever sets',
      );
    });

    test('every inherited flag is required by at least one card', () {
      // The mirror check. An inherited flag no card gates on would mean the
      // father could earn an enemy the son never meets.
      final Set<String> required = <String>{
        for (final GameCard card in _deck()) ...card.requires.flags,
      };
      expect(
        GameFlags.inheritedFlags.difference(required),
        isEmpty,
        reason: 'inherited flags no card is gated on',
      );
    });

    test('every inherited flag is reachable from some run flag', () {
      // An enemy or debt that no father-run flag can produce would gate its
      // cards behind something unreachable.
      final Set<String> producible = Legacy(
        enemies: Legacy.enemyFromFlag.values.toSet(),
        debts: Legacy.debtFromFlag.values.toSet(),
      ).flags;
      expect(GameFlags.inheritedFlags.difference(producible), isEmpty);
      expect(producible.difference(GameFlags.inheritedFlags), isEmpty);
    });

    test('no card is gated behind a flag nothing can produce', () {
      final Set<String> reachable = <String>{
        ..._settableByCards(),
        ...GameFlags.inheritedFlags,
      };

      for (final GameCard card in _deck()) {
        for (final String flag in card.requires.flags) {
          expect(
            reachable,
            contains(flag),
            reason: '${card.id} requires "$flag", which nothing produces',
          );
        }
      }
    });

    test('heir cards are gated, and father cards are not', () {
      for (final GameCard card in _deck()) {
        final bool gatedOnInheritance = card.requires.flags
            .any(GameFlags.inheritedFlags.contains);
        if (card.id.startsWith('heir_')) {
          expect(
            gatedOnInheritance,
            isTrue,
            reason: '${card.id} should carry the father\'s mess',
          );
        } else {
          expect(
            gatedOnInheritance,
            isFalse,
            reason: '${card.id} should be reachable in a first run',
          );
        }
      }
    });

    test('ids are unique', () {
      final Set<String> ids = <String>{
        for (final Object? card in decoded! as List<dynamic>)
          (card! as Map<String, dynamic>)['id'] as String,
      };
      expect(ids.length, 39);
    });
  });

  // The deck that actually ships, read off disk and validated the way
  // CardRepository.loadDeck validates it: concatenated, not file by file.
  //
  // These four checks lived in a throwaway script for three batches while the
  // batch files were not in deckPaths, which is how 300 written cards sat
  // outside a green test run. They belong here.
  group('shipped batch deck', () {
    /// cast.md, the sixteen. The exact speaker strings, and the flags that
    /// silence each of them: a card spoken by a dead man is the single most
    /// likely mistake across 900 cards.
    const Map<String, List<String>> silenceFlags = <String, List<String>>{
      'UNCLE SALLY': <String>['sally_dead'],
      'GIULIA': <String>[], // no silence flag, by design
      'CONCETTA': <String>['concetta_dead'],
      'MATTY': <String>['matty_dead'],
      'AURELIO': <String>['aurelio_dead'],
      'DUKE': <String>['duke_dead'],
      'ANGELO': <String>['angelo_dead'],
      'CAPT. KIERNAN': <String>['kiernan_gone'],
      'DET. RANIERI': <String>['ranieri_dead'],
      'DON BRACA': <String>['braca_dead'],
      'FALLON': <String>['fallon_dead'],
      'ADLER': <String>['adler_ran', 'adler_dead'],
      'MOE WILLS': <String>['wills_dead'],
      'ROSA': <String>['rosa_gone'],
      'FATHER COLLA': <String>['colla_gone'],
      'DR. NARDI': <String>['nardi_gone'],
    };

    /// cast.md's reserve voices. A reserve voice is never a person.
    const Set<String> reserveVoices = <String>{
      'THE STREET', 'THE CLUB', 'A SOLDIER', 'THE PAPERS', 'THE PHONE',
    };

    List<dynamic> concatenated() => <dynamic>[
          for (final String path in CardRepository.deckPaths)
            ...jsonDecode(File(path).readAsStringSync()) as List<dynamic>,
        ];

    List<GameCard> shipped() => CardRepository.parseDeck(
          jsonEncode(concatenated()),
          throwOnInvalid: true,
        );

    test('every batch file in deckPaths exists', () {
      for (final String path in CardRepository.deckPaths) {
        expect(File(path).existsSync(), isTrue, reason: '$path is missing');
      }
    });

    test('the concatenated deck validates, ids unique across batches', () {
      final List<dynamic> deck = concatenated();
      final List<CardIssue> issues = CardValidator.validateDeck(deck);
      expect(issues, isEmpty, reason: '\n${_messages(issues)}');
      expect(deck.length, CardRepository.deckPaths.length * 100);
    });

    test('every required flag is set by some card in the deck', () {
      final List<GameCard> deck = shipped();
      final Set<String> settable = <String>{
        for (final GameCard card in deck) ...card.left.setFlags,
        for (final GameCard card in deck) ...card.right.setFlags,
        ...GameFlags.inheritedFlags,
      };
      for (final GameCard card in deck) {
        for (final String flag in card.requires.flags) {
          expect(
            settable,
            contains(flag),
            reason: '${card.id} requires "$flag", which no card sets',
          );
        }
      }
    });

    test('every speaker is one of the sixteen or a reserve voice', () {
      for (final GameCard card in shipped()) {
        expect(
          silenceFlags.containsKey(card.speaker) ||
              reserveVoices.contains(card.speaker),
          isTrue,
          reason: '${card.id} is spoken by "${card.speaker}", who is not in '
              'cast.md',
        );
      }
    });

    // Chain structure. The shape rules (contiguous beats, one card per beat,
    // the id naming its own opener) are in CardValidator, because a chain the
    // engine cannot walk stalls the queue at runtime. These are the authoring
    // rules: they need judgement about branches, and they belong here.
    group('chains', () {
      /// Chains written before a rule existed. They ship as they are — a rare
      /// over-long or one-branch storyline is a better problem than a rewrite —
      /// and they are named so batches 7-9 do not copy the shape.
      const Set<String> legacyLongChains = <String>{'b3_076', 'b6_076'};
      const Set<String> legacyOneBranch = <String>{'b1_086'};
      const int maxBeats = 4;

      Map<String, List<GameCard>> chains() {
        final Map<String, List<GameCard>> out = <String, List<GameCard>>{};
        for (final GameCard card in shipped()) {
          final CardChain? c = card.chain;
          if (c != null) out.putIfAbsent(c.id, () => <GameCard>[]).add(card);
        }
        for (final List<GameCard> beats in out.values) {
          beats.sort((GameCard a, GameCard b) =>
              a.chain!.beat.compareTo(b.chain!.beat));
        }
        return out;
      }

      test('every batch contributes exactly twenty beats', () {
        final Map<String, int> perBatch = <String, int>{};
        for (final GameCard card in shipped()) {
          if (card.chain == null) continue;
          final String batch = card.id.substring(0, card.id.indexOf('_'));
          perBatch[batch] = (perBatch[batch] ?? 0) + 1;
        }
        expect(perBatch.values, everyElement(20), reason: '$perBatch');
        expect(perBatch.length, CardRepository.deckPaths.length);
      });

      test('each beat is gated on a flag its predecessor sets', () {
        chains().forEach((String id, List<GameCard> beats) {
          for (int i = 1; i < beats.length; i++) {
            final Set<String> sets = <String>{
              ...beats[i - 1].left.setFlags,
              ...beats[i - 1].right.setFlags,
            };
            expect(
              beats[i].requires.flags.any(sets.contains),
              isTrue,
              reason: '${beats[i].id} requires '
                  '${beats[i].requires.flags} but ${beats[i - 1].id} sets '
                  '$sets, so the queue would pin a beat that can never be '
                  'delivered',
            );
          }
        });
      });

      test('the gate is set on BOTH sides, so no branch dead-ends', () {
        chains().forEach((String id, List<GameCard> beats) {
          if (legacyOneBranch.contains(id)) return;
          for (int i = 1; i < beats.length; i++) {
            final Set<String> left = beats[i - 1].left.setFlags.toSet();
            final Set<String> right = beats[i - 1].right.setFlags.toSet();
            expect(
              beats[i].requires.flags
                  .any((String f) => left.contains(f) && right.contains(f)),
              isTrue,
              reason: '${beats[i - 1].id} -> ${beats[i].id}: the gate is set on '
                  'one side only, so the chain dies on the branch the player '
                  'did not take',
            );
          }
        });
      });

      test('no beat sets a flag a later beat of its own chain excludes', () {
        chains().forEach((String id, List<GameCard> beats) {
          for (int i = 0; i < beats.length; i++) {
            final Set<String> sets = <String>{
              ...beats[i].left.setFlags,
              ...beats[i].right.setFlags,
            };
            for (int j = i + 1; j < beats.length; j++) {
              final Iterable<String> clash =
                  beats[j].requires.excludesFlags.where(sets.contains);
              expect(
                clash,
                isEmpty,
                reason: '${beats[i].id} can set ${clash.join(',')} which '
                    '${beats[j].id} excludes: the beat would be born '
                    'contradicted and dropped at delivery',
              );
            }
          }
        });
      });

      test('chains are at most four beats, legacy exceptions aside', () {
        chains().forEach((String id, List<GameCard> beats) {
          if (legacyLongChains.contains(id)) {
            expect(beats.length, 6, reason: '$id is a recorded six-beat burn');
            return;
          }
          expect(
            beats.length,
            lessThanOrEqualTo(maxBeats),
            reason: 'chain "$id" is ${beats.length} beats. At a gap of two or '
                'three that is most of a median run; the brief caps chains at '
                '$maxBeats.',
          );
        });
      });

      test('only openers are reachable from the ordinary pool', () {
        // A non-opener beat must have a gate, or the pool could have drawn it
        // cold before the queue existed and the annotation is wrong.
        for (final GameCard card in shipped()) {
          final CardChain? c = card.chain;
          if (c == null || c.isOpener) continue;
          expect(card.requires.flags, isNotEmpty, reason: card.id);
          expect(card.once, isTrue, reason: '${card.id} is a beat and repeats');
        }
      });
    });

    test('nobody speaks after they are silenced', () {
      // cast.md hard rule 2. Every card a cast member speaks carries all of
      // that member's silence flags in requires.excludesFlags.
      for (final GameCard card in shipped()) {
        for (final String flag in silenceFlags[card.speaker] ?? <String>[]) {
          expect(
            card.requires.excludesFlags,
            contains(flag),
            reason: '${card.id}: ${card.speaker} speaks without excluding '
                '"$flag"',
          );
        }
      }
    });
  });

  group('validator catches', () {
    test('duplicate ids, naming the card', () {
      final List<CardIssue> issues = CardValidator.validateDeck(
        <dynamic>[_card('core_01'), _card('core_01')],
      );
      expect(issues, hasLength(1));
      expect(issues.single.cardId, 'core_01');
      expect(issues.single.toString(), contains('duplicate id'));
      expect(issues.single.toString(), contains('core_01'));
    });

    test('a misspelled key, as both unknown and missing', () {
      final Map<String, dynamic> card = _card('core_typo');
      final Map<String, dynamic> effects =
          (card['left'] as Map<String, dynamic>)['effects']
              as Map<String, dynamic>;
      effects['commision'] = effects.remove('commission');

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('unknown key "commision"'));
      expect(text, contains('missing required key "commission"'));
      expect(text, contains('core_typo'));
    });

    test('an unknown key at card level', () {
      final Map<String, dynamic> card = _card('core_extra')
        ..['difficulty'] = 3;
      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('unknown key "difficulty" in card'));
      expect(text, contains('core_extra'));
    });

    test('a missing required field', () {
      final Map<String, dynamic> card = _card('core_missing')..remove('text');
      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('missing required key "text"'));
      expect(text, contains('core_missing'));
    });

    test('an effect above the sane range', () {
      final Map<String, dynamic> card = _card('core_big');
      ((card['right'] as Map<String, dynamic>)['effects']
          as Map<String, dynamic>)['cash'] = 500;

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('right.effects.cash is 500'));
      expect(text, contains('outside the sane range'));
      expect(text, contains('core_big'));
    });

    test('an effect below the sane range', () {
      final Map<String, dynamic> card = _card('core_small');
      ((card['left'] as Map<String, dynamic>)['effects']
          as Map<String, dynamic>)['blood'] = -9999;

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('left.effects.blood is -9999'));
      expect(text, contains('core_small'));
    });

    test('a negative blood cost', () {
      final Map<String, dynamic> card = _card('core_giveback');
      ((card['right'] as Map<String, dynamic>)['effects']
          as Map<String, dynamic>)['blood'] = -5;

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('blood is a cost and cannot be negative'));
      expect(text, contains('core_giveback'));
    });

    test('a weight of zero', () {
      final Map<String, dynamic> card = _card('core_zero')..['weight'] = 0;
      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('weight must be greater than zero, got 0'));
      expect(text, contains('core_zero'));
    });

    test('a negative weight', () {
      final Map<String, dynamic> card = _card('core_neg')..['weight'] = -4;
      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('weight must be greater than zero, got -4'));
      expect(text, contains('core_neg'));
    });

    test('a wrong-typed field', () {
      final Map<String, dynamic> card = _card('core_type')..['once'] = 'yes';
      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('once must be a boolean'));
      expect(text, contains('core_type'));
    });

    test('a card whose id is missing, falling back to the index', () {
      final Map<String, dynamic> card = _card('core_noid')..remove('id');
      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('card at index 0 (no usable id)'));
      expect(text, contains('missing required key "id"'));
    });

    test('a setFlags entry that is not in the flag registry', () {
      final Map<String, dynamic> card = _card('core_typo_flag');
      (card['right'] as Map<String, dynamic>)['setFlags'] = <dynamic>[
        'docks_taekn',
      ];

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('unknown flag "docks_taekn" in right.setFlags'));
      expect(text, contains('core_typo_flag'));
    });

    test('a requires.flags entry that is not in the registry', () {
      final Map<String, dynamic> card = _card('core_bad_req');
      (card['requires'] as Map<String, dynamic>)['flags'] = <dynamic>[
        'at_war_maybe',
      ];

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('unknown flag "at_war_maybe" in requires.flags'));
      expect(text, contains('core_bad_req'));
    });

    test('a requires.excludesFlags entry that is not in the registry', () {
      final Map<String, dynamic> card = _card('core_bad_excl');
      (card['requires'] as Map<String, dynamic>)['excludesFlags'] = <dynamic>[
        'retired',
      ];

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(
        text,
        contains('unknown flag "retired" in requires.excludesFlags'),
      );
      expect(text, contains('core_bad_excl'));
    });

    test('a deck with no always-eligible filler card', () {
      final Map<String, dynamic> card = _card('core_gated');
      (card['requires'] as Map<String, dynamic>)['flags'] = <dynamic>[
        GameFlags.atWar,
      ];

      final String text = _messages(
        CardValidator.validateDeck(<dynamic>[card]),
      );
      expect(text, contains('no always-eligible filler card'));
    });

    test('a non-list root', () {
      final List<CardIssue> issues =
          CardValidator.validateDeck(<String, dynamic>{'cards': <dynamic>[]});
      expect(issues, hasLength(1));
      expect(issues.single.toString(), contains('must be a JSON list'));
    });

    test('an empty deck', () {
      final List<CardIssue> issues = CardValidator.validateDeck(<dynamic>[]);
      expect(issues, hasLength(1));
      expect(issues.single.toString(), contains('deck is empty'));
    });
  });

  group('assertDeckValid', () {
    test('throws listing every issue', () {
      expect(
        () => CardValidator.assertDeckValid(<dynamic>[
          _card('core_a')..['weight'] = 0,
          _card('core_a'),
        ]),
        throwsA(
          isA<CardValidationException>().having(
            (CardValidationException e) => e.toString(),
            'message',
            allOf(contains('core_a'), contains('weight')),
          ),
        ),
      );
    });

    test('stays quiet on a good deck', () {
      expect(
        () => CardValidator.assertDeckValid(<dynamic>[_card('core_ok')]),
        returnsNormally,
      );
    });
  });

  group('startup check', () {
    // Tests run with kDebugMode true, which is the same default main() gets,
    // so this covers the on-startup behaviour rather than just the explicit
    // throwOnInvalid path.
    test('parseDeck throws by default on a bad deck', () {
      final String source = jsonEncode(<dynamic>[_card('core_bad')..['weight'] = 0]);
      expect(
        () => CardRepository.parseDeck(source),
        throwsA(
          isA<CardValidationException>().having(
            (CardValidationException e) => e.toString(),
            'message',
            contains('core_bad'),
          ),
        ),
      );
    });

    test('parseDeck accepts the shipped deck by default', () {
      expect(
        () => CardRepository.parseDeck(
          File('assets/cards/core.json').readAsStringSync(),
        ),
        returnsNormally,
      );
    });
  });
}

