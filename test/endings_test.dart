// Ending copy checks:  flutter test

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_reigns/ending.dart';
import 'package:mafia_reigns/endings_repository.dart';

String _source() => File('assets/cards/endings.json').readAsStringSync();

Map<String, dynamic> _valid() => <String, dynamic>{
      for (final MeterKind meter in MeterKind.values)
        meter.name: <String, dynamic>{
          for (final MeterBound bound in MeterBound.values)
            bound.name: <String, dynamic>{
              'title': 'TITLE',
              'text': 'Some ending text.',
            },
        },
    };

void main() {
  group('shipped endings', () {
    test('pass validation', () {
      final List<String> errors =
          EndingsRepository.validate(jsonDecode(_source()));
      expect(errors, isEmpty, reason: '\n${errors.join('\n')}');
    });

    test('there are exactly eight, one per meter per bound', () {
      final EndingSet endings =
          EndingsRepository.parse(_source(), throwOnInvalid: true);

      expect(endings.length, 8);
      for (final MeterKind meter in MeterKind.values) {
        for (final MeterBound bound in MeterBound.values) {
          final Ending ending = endings.lookup(meter, bound);
          expect(ending.meter, meter);
          expect(ending.bound, bound);
          expect(ending.title.trim(), isNotEmpty);
          expect(ending.text.trim(), isNotEmpty);
        }
      }
    });

    test('every ending is at least two sentences', () {
      final EndingSet endings =
          EndingsRepository.parse(_source(), throwOnInvalid: true);

      for (final Ending ending in endings.all) {
        final int sentences =
            ending.text.split(RegExp(r'[.!?]')).where((String part) {
          return part.trim().isNotEmpty;
        }).length;
        expect(
          sentences,
          greaterThanOrEqualTo(2),
          reason: '${ending.title} reads as one sentence',
        );
      }
    });

    test('ending titles are unique', () {
      final EndingSet endings =
          EndingsRepository.parse(_source(), throwOnInvalid: true);
      final Set<String> titles =
          endings.all.map((Ending e) => e.title).toSet();
      expect(titles.length, 8);
    });
  });

  group('validator catches', () {
    test('a missing meter', () {
      final Map<String, dynamic> data = _valid()..remove('cops');
      expect(
        EndingsRepository.validate(data).join('\n'),
        contains('missing meter "cops"'),
      );
    });

    test('a missing direction', () {
      final Map<String, dynamic> data = _valid();
      (data['cash']! as Map<String, dynamic>).remove('full');
      expect(
        EndingsRepository.validate(data).join('\n'),
        contains('missing ending "cash.full"'),
      );
    });

    test('an unknown meter', () {
      final Map<String, dynamic> data = _valid()
        ..['blood'] = <String, dynamic>{};
      expect(
        EndingsRepository.validate(data).join('\n'),
        contains('unknown meter "blood"'),
      );
    });

    test('a misspelled key inside an ending', () {
      final Map<String, dynamic> data = _valid();
      final Map<String, dynamic> entry =
          (data['family']! as Map<String, dynamic>)['empty']!
              as Map<String, dynamic>;
      entry['titel'] = entry.remove('title');

      final String text = EndingsRepository.validate(data).join('\n');
      expect(text, contains('unknown key "titel" in family.empty'));
      expect(text, contains('missing required key "title" in family.empty'));
    });

    test('empty copy', () {
      final Map<String, dynamic> data = _valid();
      ((data['commission']! as Map<String, dynamic>)['full']!
          as Map<String, dynamic>)['text'] = '   ';
      expect(
        EndingsRepository.validate(data).join('\n'),
        contains('commission.full.text must not be empty'),
      );
    });

    test('a non-object root', () {
      expect(
        EndingsRepository.validate(<dynamic>[]).join('\n'),
        contains('root must be a JSON object'),
      );
    });
  });

  test('parse throws by default on invalid endings', () {
    expect(
      () => EndingsRepository.parse(jsonEncode(_valid()..remove('family'))),
      throwsA(isA<EndingsValidationException>()),
    );
  });
}
