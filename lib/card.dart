/// Card model classes.
///
/// The `fromJson` constructors here assume the JSON has already been through
/// [CardValidator]. They cast rather than defensively coerce, so a malformed
/// deck fails in the validator with a readable message and a card id, not
/// halfway through parsing with a raw type error.
library;

/// Meter deltas carried by one side of a card.
///
/// `blood` is modelled now although nothing reads it yet.
class CardEffects {
  const CardEffects({
    required this.family,
    required this.commission,
    required this.cops,
    required this.cash,
    required this.blood,
  });

  final int family;
  final int commission;
  final int cops;
  final int cash;
  final int blood;

  /// Every key the effects map is allowed to carry, and must carry.
  static const Set<String> keys = <String>{
    'family',
    'commission',
    'cops',
    'cash',
    'blood',
  };

  factory CardEffects.fromJson(Map<String, dynamic> json) {
    return CardEffects(
      family: json['family'] as int,
      commission: json['commission'] as int,
      cops: json['cops'] as int,
      cash: json['cash'] as int,
      blood: json['blood'] as int,
    );
  }
}

/// One side of a card — the outcome of answering in that direction.
///
/// Nothing applies these yet; they are data only.
class CardChoice {
  const CardChoice({
    required this.label,
    required this.effects,
    required this.setFlags,
  });

  final String label;
  final CardEffects effects;
  final List<String> setFlags;

  static const Set<String> keys = <String>{'label', 'effects', 'setFlags'};

  factory CardChoice.fromJson(Map<String, dynamic> json) {
    return CardChoice(
      label: json['label'] as String,
      effects: CardEffects.fromJson(json['effects'] as Map<String, dynamic>),
      setFlags: (json['setFlags'] as List<dynamic>).cast<String>(),
    );
  }
}

/// Flag gating for a card. Stored but not yet enforced.
class CardRequires {
  const CardRequires({required this.flags, required this.excludesFlags});

  final List<String> flags;
  final List<String> excludesFlags;

  static const Set<String> keys = <String>{'flags', 'excludesFlags'};

  factory CardRequires.fromJson(Map<String, dynamic> json) {
    return CardRequires(
      flags: (json['flags'] as List<dynamic>).cast<String>(),
      excludesFlags: (json['excludesFlags'] as List<dynamic>).cast<String>(),
    );
  }
}

/// A card's position in a multi-card chain.
///
/// The second sanctioned schema addition, after `vice`, and it exists because
/// the opener-to-follow-up relation had no machine-readable form at all: it
/// lived in the *Set by / Read by* columns of docs/flag-registry.md and in the
/// `b{N}_076`-`b{N}_095` id convention. Nothing the engine could read.
///
/// Inferring it was tried and rejected. The obvious rule — *this card sets flag
/// F on both sides, so cards requiring F are its follow-ups* — misfires on 18
/// of the 87 both-sides flags in the deck, because character and world flags
/// are deliberately set on both sides too ("the dying is the event, the choice
/// is only what you do about it"). `aurelio_dead` alone is required by five
/// suppression variants, so an inferring queue would deliver the whole
/// post-Aurelio budget as a five-card cutscene the moment he died.
class CardChain {
  const CardChain({required this.id, required this.beat});

  /// The opener's card id, which names the chain.
  final String id;

  /// 1 for the opener. Contiguous within a chain.
  final int beat;

  bool get isOpener => beat == 1;

  static const Set<String> keys = <String>{'id', 'beat'};

  factory CardChain.fromJson(Map<String, dynamic> json) =>
      CardChain(id: json['id'] as String, beat: json['beat'] as int);
}

class GameCard {
  const GameCard({
    required this.id,
    required this.speaker,
    required this.text,
    required this.left,
    required this.right,
    required this.requires,
    required this.weight,
    required this.once,
    this.vice = false,
    this.chain,
  });

  final String id;
  final String speaker;
  final String text;
  final CardChoice left;
  final CardChoice right;
  final CardRequires requires;

  /// A **vice**: a card that denies the player the pull-back.
  ///
  /// Ordinary cards let a careful player steer — whichever meter has drifted,
  /// one of the two sides pulls it back. A vice does not: no meter is moved
  /// in opposite directions by the two sides, so the player chooses which
  /// damage to take and never whether to take it. At least one meter is
  /// pushed the same way by both sides by 8 or more.
  ///
  /// Optional and defaulting false, because the flag is the *only* thing that
  /// separates a deliberate vice from the accident batch 2 shipped thirteen
  /// of. [CardValidator] fails any undeclared card whose two sides push a
  /// meter the same way by 5 or more, and [DeckBalance] fails a batch whose
  /// vices all lean the same way.
  final bool vice;

  /// Which chain this card is a beat of, and which beat. Null for the ~80% of
  /// the deck that is standalone.
  ///
  /// Read by [GameState] to deliver a chain causally rather than
  /// probabilistically: a follow-up at draw weight 45 among 364 eligible cards
  /// had roughly a 1% chance of being reached by the third beat, which made the
  /// most effortful writing in the deck unreachable.
  final CardChain? chain;

  /// Relative draw weight. Nothing draws yet; the validator only insists it
  /// is positive so a future draw cannot silently exclude the card.
  final int weight;

  /// Whether the card should be retired after being seen. Not yet enforced.
  final bool once;

  static const Set<String> keys = <String>{
    'id',
    'speaker',
    'text',
    'left',
    'right',
    'requires',
    'weight',
    'once',
  };

  /// Keys a card may carry but need not. Everything in [keys] is required;
  /// these are the two additions the schema has taken since batch 1, both
  /// sanctioned in docs/content-prompt.md.
  static const Set<String> optionalKeys = <String>{'vice', 'chain'};

  factory GameCard.fromJson(Map<String, dynamic> json) {
    return GameCard(
      id: json['id'] as String,
      speaker: json['speaker'] as String,
      text: json['text'] as String,
      left: CardChoice.fromJson(json['left'] as Map<String, dynamic>),
      right: CardChoice.fromJson(json['right'] as Map<String, dynamic>),
      requires: CardRequires.fromJson(json['requires'] as Map<String, dynamic>),
      weight: json['weight'] as int,
      once: json['once'] as bool,
      vice: json['vice'] as bool? ?? false,
      chain: json['chain'] == null
          ? null
          : CardChain.fromJson(json['chain']! as Map<String, dynamic>),
    );
  }
}
