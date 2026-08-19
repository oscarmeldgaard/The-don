import 'card.dart';
import 'flags.dart';

/// One problem found in the deck, tagged with the card it came from.
class CardIssue {
  const CardIssue({
    required this.index,
    required this.cardId,
    required this.message,
  });

  /// Position in the deck file. `-1` for deck-level problems.
  final int index;

  /// The offending card's id, or null when the id itself is missing/unusable.
  final String? cardId;

  final String message;

  String get location {
    if (index < 0) return 'deck';
    final String? id = cardId;
    if (id == null || id.isEmpty) return 'card at index $index (no usable id)';
    return 'card "$id"';
  }

  @override
  String toString() => '$location: $message';
}

/// Thrown when a deck fails validation. Lists every problem, not just the
/// first, so a bad deck can be fixed in one pass.
class CardValidationException implements Exception {
  const CardValidationException(this.issues);

  final List<CardIssue> issues;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer(
      'Card deck validation failed with ${issues.length} issue(s):',
    );
    for (final CardIssue issue in issues) {
      buffer.write('\n  - $issue');
    }
    return buffer.toString();
  }
}

/// Validates a decoded deck before it is turned into [GameCard]s.
///
/// Deliberately operates on raw JSON: unknown keys and missing fields are
/// invisible once the data has been through a model constructor.
class CardValidator {
  const CardValidator._();

  /// Bounds on a single meter delta. A card outside this is almost certainly
  /// a typo (an extra zero) rather than an intentional swing.
  static const int minEffect = -50;
  static const int maxEffect = 50;

  /// Returns every problem found. Empty means the deck is good.
  static List<CardIssue> validateDeck(Object? decoded) {
    final List<CardIssue> issues = <CardIssue>[];

    if (decoded is! List) {
      issues.add(
        CardIssue(
          index: -1,
          cardId: null,
          message: 'deck root must be a JSON list, got ${decoded.runtimeType}',
        ),
      );
      return issues;
    }

    if (decoded.isEmpty) {
      issues.add(
        const CardIssue(index: -1, cardId: null, message: 'deck is empty'),
      );
      return issues;
    }

    final Map<String, int> seenIds = <String, int>{};

    for (int i = 0; i < decoded.length; i++) {
      final Object? entry = decoded[i];

      if (entry is! Map<String, dynamic>) {
        issues.add(
          CardIssue(
            index: i,
            cardId: null,
            message: 'card must be a JSON object, got ${entry.runtimeType}',
          ),
        );
        continue;
      }

      final Object? rawId = entry['id'];
      final String? id = rawId is String && rawId.isNotEmpty ? rawId : null;

      if (id != null) {
        final int? firstIndex = seenIds[id];
        if (firstIndex != null) {
          issues.add(
            CardIssue(
              index: i,
              cardId: id,
              message: 'duplicate id (first seen at index $firstIndex)',
            ),
          );
        } else {
          seenIds[id] = i;
        }
      }

      _validateCard(entry, i, id, issues);
    }

    _validateChains(decoded, issues);

    if (!_hasFillerCard(decoded)) {
      issues.add(
        const CardIssue(
          index: -1,
          cardId: null,
          message:
              'deck has no always-eligible filler card (one with no '
              'requires.flags, no requires.excludesFlags and once=false); '
              'selection would have nothing to fall back on',
        ),
      );
    }

    return issues;
  }

  /// True if at least one card can never be filtered out, which is what
  /// guarantees card selection always has something to return.
  static bool _hasFillerCard(List<dynamic> deck) {
    for (final Object? entry in deck) {
      if (entry is! Map<String, dynamic>) continue;
      if (entry['once'] != false) continue;
      final Object? requires = entry['requires'];
      if (requires is! Map<String, dynamic>) continue;
      final Object? flags = requires['flags'];
      final Object? excludes = requires['excludesFlags'];
      if (flags is List &&
          flags.isEmpty &&
          excludes is List &&
          excludes.isEmpty) {
        return true;
      }
    }
    return false;
  }

  /// Throws [CardValidationException] if anything is wrong.
  static void assertDeckValid(Object? decoded) {
    final List<CardIssue> issues = validateDeck(decoded);
    if (issues.isNotEmpty) {
      throw CardValidationException(issues);
    }
  }

  static void _validateCard(
    Map<String, dynamic> card,
    int index,
    String? id,
    List<CardIssue> issues,
  ) {
    _checkKeys(
      card,
      GameCard.keys,
      'card',
      index,
      id,
      issues,
      optional: GameCard.optionalKeys,
    );

    _checkString(card, 'id', 'card', index, id, issues);
    _checkString(card, 'speaker', 'card', index, id, issues);
    _checkString(card, 'text', 'card', index, id, issues);

    for (final String side in <String>['left', 'right']) {
      final Map<String, dynamic>? choice = _asMap(
        card,
        side,
        'card',
        index,
        id,
        issues,
      );
      if (choice != null) {
        _validateChoice(choice, side, index, id, issues);
      }
    }

    final Map<String, dynamic>? requires = _asMap(
      card,
      'requires',
      'card',
      index,
      id,
      issues,
    );
    if (requires != null) {
      _checkKeys(requires, CardRequires.keys, 'requires', index, id, issues);
      _checkStringList(
        requires,
        'flags',
        'requires',
        index,
        id,
        issues,
        registry: GameFlags.registry,
      );
      _checkStringList(
        requires,
        'excludesFlags',
        'requires',
        index,
        id,
        issues,
        registry: GameFlags.registry,
      );
    }

    if (card.containsKey('weight')) {
      final Object? weight = card['weight'];
      if (weight is! int) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                'weight must be an integer, got ${weight.runtimeType} ($weight)',
          ),
        );
      } else if (weight <= 0) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message: 'weight must be greater than zero, got $weight',
          ),
        );
      }
    }

    if (card.containsKey('once') && card['once'] is! bool) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: 'once must be a boolean, got ${card['once'].runtimeType}',
        ),
      );
    }

    if (card.containsKey('vice') && card['vice'] is! bool) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: 'vice must be a boolean, got ${card['vice'].runtimeType}',
        ),
      );
    }

    _checkVice(card, index, id, issues);
    _checkChainShape(card, index, id, issues);
  }

  /// Shape only. The structural rules that need the whole deck — contiguous
  /// beats, one card per beat, the chain id naming its own opener — are in
  /// [validateDeck]; the authoring rules that need judgement about branches are
  /// in the test suite, because they are authoring constraints rather than
  /// things that can crash a run.
  static void _checkChainShape(
    Map<String, dynamic> card,
    int index,
    String? id,
    List<CardIssue> issues,
  ) {
    if (!card.containsKey('chain')) return;
    final Object? chain = card['chain'];
    if (chain is! Map<String, dynamic>) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: 'chain must be an object, got ${chain.runtimeType}',
        ),
      );
      return;
    }
    _checkKeys(chain, CardChain.keys, 'chain', index, id, issues);
    _checkString(chain, 'id', 'chain', index, id, issues);
    if (chain.containsKey('beat')) {
      final Object? beat = chain['beat'];
      if (beat is! int) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message: 'chain.beat must be an integer, got ${beat.runtimeType}',
          ),
        );
      } else if (beat < 1) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message: 'chain.beat must be 1 or greater, got $beat',
          ),
        );
      }
    }
  }

  /// Deck-level chain structure.
  ///
  /// A chain the engine cannot walk is worse than no chain at all: the queue
  /// would hold a beat that never arrives, and while it holds one no other
  /// chain can open. So these are load-time failures, not authoring notes.
  static void _validateChains(List<dynamic> deck, List<CardIssue> issues) {
    final Map<String, Map<int, List<String>>> byChain =
        <String, Map<int, List<String>>>{};

    for (final Object? entry in deck) {
      if (entry is! Map<String, dynamic>) continue;
      final Object? chain = entry['chain'];
      if (chain is! Map<String, dynamic>) continue;
      final Object? cid = chain['id'];
      final Object? beat = chain['beat'];
      if (cid is! String || beat is! int) continue;
      final Object? id = entry['id'];
      byChain
          .putIfAbsent(cid, () => <int, List<String>>{})
          .putIfAbsent(beat, () => <String>[])
          .add(id is String ? id : '?');
    }

    byChain.forEach((String cid, Map<int, List<String>> beats) {
      for (final MapEntry<int, List<String>> e in beats.entries) {
        if (e.value.length > 1) {
          issues.add(
            CardIssue(
              index: -1,
              cardId: null,
              message:
                  'chain "$cid" has ${e.value.length} cards at beat '
                  '${e.key} (${e.value.join(', ')}); a beat is one card',
            ),
          );
        }
      }
      final List<int> present = beats.keys.toList()..sort();
      for (int i = 0; i < present.length; i++) {
        if (present[i] != i + 1) {
          issues.add(
            CardIssue(
              index: -1,
              cardId: null,
              message:
                  'chain "$cid" has beats ${present.join(',')}; beats must '
                  'run 1..n with no gaps, or the queue stalls at the hole',
            ),
          );
          break;
        }
      }
      final List<String>? opener = beats[1];
      if (opener == null) {
        issues.add(
          CardIssue(
            index: -1,
            cardId: null,
            message: 'chain "$cid" has no beat 1, so nothing can open it',
          ),
        );
      } else if (opener.length == 1 && opener.single != cid) {
        issues.add(
          CardIssue(
            index: -1,
            cardId: null,
            message:
                'chain "$cid" names itself after a card that is not its '
                'opener; beat 1 is "${opener.single}". The chain id is the '
                "opener's id so the pair cannot drift.",
          ),
        );
      }
    });
  }

  /// Smallest same-direction push on both sides that counts as deliberate
  /// rather than garnish. Below this it is a rounding artefact; at or above
  /// it, the card is taking a meter's choice away from the player.
  static const int viceThreshold = 5;

  /// A vice must be declared, and a declaration must be earned.
  ///
  /// Batch 2 shipped thirteen cards where both sides pushed one meter the
  /// same way, none of them on purpose, and nothing caught it for three
  /// batches. But sharing a meter is not by itself the harm: six of those
  /// thirteen are fine, because money moves the same way whichever side you
  /// take and the *decision* lives on another meter — a condolence costs
  /// whether you go or send, and the branch is standing. The harm is a card
  /// that shares a meter and offers **no lever anywhere**, which is a card
  /// with a meter it simply takes.
  ///
  /// So an undeclared card fails when both conditions hold: some meter is
  /// pushed the same way by both sides by [viceThreshold] or more, *and* no
  /// meter moves in opposite directions across the two sides. A card that
  /// says `vice: true` must earn it the other way — a same-direction push of
  /// 8 or more, and no opposing meter at all, because a vice whose whole
  /// point is denying the pull-back cannot then hand one back.
  static void _checkVice(
    Map<String, dynamic> card,
    int index,
    String? id,
    List<CardIssue> issues,
  ) {
    final Object? left = card['left'];
    final Object? right = card['right'];
    if (left is! Map<String, dynamic> || right is! Map<String, dynamic>) return;
    final Object? l = left['effects'];
    final Object? r = right['effects'];
    if (l is! Map<String, dynamic> || r is! Map<String, dynamic>) return;

    final bool declared = card['vice'] == true;
    final List<String> shared = <String>[];
    bool earnsIt = false;
    bool contradicts = false;

    for (final String meter in CardEffects.keys) {
      // blood only ever drains; it is never a choice of direction
      if (meter == 'blood') continue;
      final Object? a = l[meter];
      final Object? b = r[meter];
      if (a is! int || b is! int || a == 0 || b == 0) continue;
      if ((a > 0) == (b > 0)) {
        if (a.abs() >= viceThreshold && b.abs() >= viceThreshold) {
          shared.add('$meter ${_signed(a)}/${_signed(b)}');
        }
        if (a.abs() >= 8 && b.abs() >= 8) earnsIt = true;
      } else {
        contradicts = true;
      }
    }

    if (shared.isNotEmpty && !declared && !contradicts) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message:
              'both sides push the same meter the same way '
              '(${shared.join(', ')}) and no meter moves in opposite '
              'directions, so the card takes something and decides nothing. '
              'Give it a real branch on some meter, or declare "vice": true '
              'if the cost is meant to be unavoidable.',
        ),
      );
    }

    if (declared && !earnsIt) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message:
              'declared "vice": true but no meter is pushed the same way '
              'by both sides by 8 or more; a vice has to deny the player the '
              'pull-back, not merely cost something',
        ),
      );
    }

    if (declared && contradicts) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message:
              'declared "vice": true but a meter moves in opposite '
              'directions on the two sides, which hands the pull-back back',
        ),
      );
    }
  }

  static String _signed(int v) => v >= 0 ? '+$v' : '$v';

  static void _validateChoice(
    Map<String, dynamic> choice,
    String where,
    int index,
    String? id,
    List<CardIssue> issues,
  ) {
    _checkKeys(choice, CardChoice.keys, where, index, id, issues);
    _checkString(choice, 'label', where, index, id, issues);
    _checkStringList(
      choice,
      'setFlags',
      where,
      index,
      id,
      issues,
      registry: GameFlags.registry,
    );

    final Map<String, dynamic>? effects = _asMap(
      choice,
      'effects',
      where,
      index,
      id,
      issues,
    );
    if (effects == null) return;

    final String effectsWhere = '$where.effects';
    _checkKeys(effects, CardEffects.keys, effectsWhere, index, id, issues);

    for (final String key in CardEffects.keys) {
      if (!effects.containsKey(key)) continue;
      final Object? value = effects[key];
      if (value is! int) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                '$effectsWhere.$key must be an integer, got ${value.runtimeType} ($value)',
          ),
        );
      } else if (key == 'blood' && value < 0) {
        // Blood only ever drains. A negative value would hand it back.
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                '$effectsWhere.blood is $value; blood is a cost and '
                'cannot be negative',
          ),
        );
      } else if (value < minEffect || value > maxEffect) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                '$effectsWhere.$key is $value, outside the sane range '
                '$minEffect..$maxEffect',
          ),
        );
      }
    }
  }

  /// Flags both unknown/misspelled keys and missing required ones. A typo
  /// such as `commision` surfaces as both, which is the clearest signal.
  static void _checkKeys(
    Map<String, dynamic> map,
    Set<String> allowed,
    String where,
    int index,
    String? id,
    List<CardIssue> issues, {
    Set<String> optional = const <String>{},
  }) {
    for (final String key in map.keys) {
      if (!allowed.contains(key) && !optional.contains(key)) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                'unknown key "$key" in $where '
                '(allowed: ${<String>{...allowed, ...optional}.join(', ')})',
          ),
        );
      }
    }
    for (final String key in allowed) {
      if (!map.containsKey(key)) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message: 'missing required key "$key" in $where',
          ),
        );
      }
    }
  }

  static void _checkString(
    Map<String, dynamic> map,
    String key,
    String where,
    int index,
    String? id,
    List<CardIssue> issues,
  ) {
    if (!map.containsKey(key)) return;
    final Object? value = map[key];
    if (value is! String) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: '$where.$key must be a string, got ${value.runtimeType}',
        ),
      );
    } else if (value.trim().isEmpty) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: '$where.$key must not be empty',
        ),
      );
    }
  }

  /// When [registry] is given, every entry must also be a declared flag.
  /// This is the check that stops a typo turning a card into dead weight.
  static void _checkStringList(
    Map<String, dynamic> map,
    String key,
    String where,
    int index,
    String? id,
    List<CardIssue> issues, {
    Set<String>? registry,
  }) {
    if (!map.containsKey(key)) return;
    final Object? value = map[key];
    if (value is! List) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: '$where.$key must be a list, got ${value.runtimeType}',
        ),
      );
      return;
    }
    for (int i = 0; i < value.length; i++) {
      final Object? element = value[i];
      if (element is! String) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                '$where.$key[$i] must be a string, got ${element.runtimeType}',
          ),
        );
      } else if (element.trim().isEmpty) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message: '$where.$key[$i] must not be empty',
          ),
        );
      } else if (registry != null && !registry.contains(element)) {
        issues.add(
          CardIssue(
            index: index,
            cardId: id,
            message:
                'unknown flag "$element" in $where.$key '
                '(not in the flag registry)',
          ),
        );
      }
    }
  }

  static Map<String, dynamic>? _asMap(
    Map<String, dynamic> map,
    String key,
    String where,
    int index,
    String? id,
    List<CardIssue> issues,
  ) {
    if (!map.containsKey(key)) return null;
    final Object? value = map[key];
    if (value is! Map<String, dynamic>) {
      issues.add(
        CardIssue(
          index: index,
          cardId: id,
          message: '$where.$key must be an object, got ${value.runtimeType}',
        ),
      );
      return null;
    }
    return value;
  }
}
