import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'card.dart';
import 'card_validator.dart';

/// Loads and parses card decks from the asset bundle.
class CardRepository {
  const CardRepository._();

  /// The placeholder deck. **Not part of the running game.**
  ///
  /// Half of it is literal `Placeholder text:` filler and the rest was written
  /// before docs/cast.md settled the sixteen — it has a wife called Rosa, a
  /// `SAL` and an `UNCLE SALLY`, a `NICKY`. Shipping it would put two
  /// different casts in one deck. It stays on disk because the test suite uses
  /// it as a fixture for the validator, the legacy/heir gating and the widget
  /// layer, and that coverage is worth more than the tidiness of deleting it.
  static const String coreDeckPath = 'assets/cards/core.json';

  /// The real deck, in order. One line per batch as they are written.
  static const List<String> deckPaths = <String>[
    'assets/cards/batch_1.json',
    'assets/cards/batch_2.json',
    'assets/cards/batch_3.json',
    'assets/cards/batch_4.json',
    'assets/cards/batch_5.json',
    'assets/cards/batch_6.json',
    'assets/cards/batch_7.json',
    'assets/cards/batch_8.json',
    'assets/cards/batch_9.json',
  ];

  /// Loads every batch in [deckPaths] and validates them as one deck.
  ///
  /// Validating the concatenation rather than each file in turn is the point:
  /// duplicate ids across two batches are exactly the mistake that a
  /// per-file check would wave through, and the b{N}_ id prefix is a
  /// convention rather than something the schema enforces.
  static Future<List<GameCard>> loadDeck(
    AssetBundle bundle, {
    List<String> paths = deckPaths,
    bool? throwOnInvalid,
  }) async {
    final List<dynamic> combined = <dynamic>[];
    for (final String path in paths) {
      final Object? decoded = jsonDecode(await bundle.loadString(path));
      if (decoded is! List) {
        throw CardValidationException(<CardIssue>[
          CardIssue(
            index: -1,
            cardId: null,
            message: '$path must be a JSON list, got ${decoded.runtimeType}',
          ),
        ]);
      }
      combined.addAll(decoded);
    }
    return _fromDecoded(combined, throwOnInvalid: throwOnInvalid);
  }

  static Future<List<GameCard>> loadFromBundle(
    AssetBundle bundle, {
    String path = coreDeckPath,
    bool? throwOnInvalid,
  }) async {
    final String source = await bundle.loadString(path);
    return parseDeck(source, throwOnInvalid: throwOnInvalid);
  }

  /// Parses a deck, validating first.
  ///
  /// [throwOnInvalid] defaults to [kDebugMode]: a bad deck is a loud crash
  /// while developing, and a logged warning with the bad cards dropped in
  /// release, so a data mistake cannot brick a shipped build. The test suite
  /// is what actually keeps release decks honest.
  static List<GameCard> parseDeck(String source, {bool? throwOnInvalid}) =>
      _fromDecoded(jsonDecode(source), throwOnInvalid: throwOnInvalid);

  static List<GameCard> _fromDecoded(Object? decoded, {bool? throwOnInvalid}) {
    final List<CardIssue> issues = CardValidator.validateDeck(decoded);
    final bool shouldThrow = throwOnInvalid ?? kDebugMode;

    if (issues.isEmpty) {
      return List<GameCard>.unmodifiable(
        (decoded! as List<dynamic>).map(
          (Object? entry) => GameCard.fromJson(entry! as Map<String, dynamic>),
        ),
      );
    }

    final CardValidationException failure = CardValidationException(issues);
    if (shouldThrow) throw failure;

    debugPrint(failure.toString());

    // Release fallback: keep whatever is well-formed, drop the rest.
    if (decoded is! List) return List<GameCard>.unmodifiable(<GameCard>[]);
    final Set<int> badIndices = issues
        .map((CardIssue issue) => issue.index)
        .toSet();
    return List<GameCard>.unmodifiable(<GameCard>[
      for (int i = 0; i < decoded.length; i++)
        if (!badIndices.contains(i))
          GameCard.fromJson(decoded[i]! as Map<String, dynamic>),
    ]);
  }
}
