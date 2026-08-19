import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ending.dart';

class EndingsValidationException implements Exception {
  const EndingsValidationException(this.errors);

  final List<String> errors;

  @override
  String toString() =>
      'Endings validation failed with ${errors.length} issue(s):'
      '\n  - ${errors.join('\n  - ')}';
}

/// Loads and validates the ending copy.
///
/// Same discipline as the card deck: a missing or misspelled key is a loud
/// failure at startup in debug, not a crash on the one swipe that reaches it.
class EndingsRepository {
  const EndingsRepository._();

  static const String endingsPath = 'assets/cards/endings.json';

  static Future<EndingSet> loadFromBundle(
    AssetBundle bundle, {
    String path = endingsPath,
    bool? throwOnInvalid,
  }) async {
    final String source = await bundle.loadString(path);
    return parse(source, throwOnInvalid: throwOnInvalid);
  }

  static EndingSet parse(String source, {bool? throwOnInvalid}) {
    final Object? decoded = jsonDecode(source);
    final List<String> errors = validate(decoded);
    final bool shouldThrow = throwOnInvalid ?? kDebugMode;

    if (errors.isNotEmpty) {
      final EndingsValidationException failure = EndingsValidationException(
        errors,
      );
      if (shouldThrow) throw failure;
      debugPrint(failure.toString());
    }

    final Map<String, Ending> byKey = <String, Ending>{};
    if (decoded is! Map<String, dynamic>) return EndingSet(byKey);

    for (final MeterKind meter in MeterKind.values) {
      final Object? group = decoded[meter.name];
      if (group is! Map<String, dynamic>) continue;
      for (final MeterBound bound in MeterBound.values) {
        final Object? entry = group[bound.name];
        if (entry is! Map<String, dynamic>) continue;
        final Object? title = entry['title'];
        final Object? text = entry['text'];
        if (title is! String || text is! String) continue;
        byKey[EndingSet.keyFor(meter, bound)] = Ending(
          meter: meter,
          bound: bound,
          title: title,
          text: text,
        );
      }
    }

    return EndingSet(byKey);
  }

  /// Every ending must be present: eight of them, one per meter per bound.
  static List<String> validate(Object? decoded) {
    final List<String> errors = <String>[];

    if (decoded is! Map<String, dynamic>) {
      errors.add('root must be a JSON object, got ${decoded.runtimeType}');
      return errors;
    }

    final Set<String> allowedMeters = MeterKind.values
        .map((MeterKind m) => m.name)
        .toSet();
    for (final String key in decoded.keys) {
      if (!allowedMeters.contains(key)) {
        errors.add(
          'unknown meter "$key" (allowed: ${allowedMeters.join(', ')})',
        );
      }
    }

    for (final MeterKind meter in MeterKind.values) {
      final Object? group = decoded[meter.name];
      if (group == null) {
        errors.add('missing meter "${meter.name}"');
        continue;
      }
      if (group is! Map<String, dynamic>) {
        errors.add(
          '"${meter.name}" must be an object, got ${group.runtimeType}',
        );
        continue;
      }

      final Set<String> allowedBounds = MeterBound.values
          .map((MeterBound b) => b.name)
          .toSet();
      for (final String key in group.keys) {
        if (!allowedBounds.contains(key)) {
          errors.add(
            'unknown direction "${meter.name}.$key" '
            '(allowed: ${allowedBounds.join(', ')})',
          );
        }
      }

      for (final MeterBound bound in MeterBound.values) {
        final String where = '${meter.name}.${bound.name}';
        final Object? entry = group[bound.name];
        if (entry == null) {
          errors.add('missing ending "$where"');
          continue;
        }
        if (entry is! Map<String, dynamic>) {
          errors.add('"$where" must be an object, got ${entry.runtimeType}');
          continue;
        }

        for (final String key in entry.keys) {
          if (!Ending.keys.contains(key)) {
            errors.add(
              'unknown key "$key" in $where (allowed: ${Ending.keys.join(', ')})',
            );
          }
        }
        for (final String key in Ending.keys) {
          final Object? value = entry[key];
          if (value == null) {
            errors.add('missing required key "$key" in $where');
          } else if (value is! String) {
            errors.add(
              '$where.$key must be a string, got ${value.runtimeType}',
            );
          } else if (value.trim().isEmpty) {
            errors.add('$where.$key must not be empty');
          }
        }
      }
    }

    return errors;
  }
}
