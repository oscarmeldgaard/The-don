/// The four meters, in the order they are checked when a run ends.
enum MeterKind { family, commission, cops, cash }

/// Which bound a meter hit.
enum MeterBound { empty, full }

class Ending {
  const Ending({
    required this.meter,
    required this.bound,
    required this.title,
    required this.text,
  });

  final MeterKind meter;
  final MeterBound bound;

  /// Short label, shown where a speaker name would normally sit.
  final String title;

  /// The ending copy itself, shown in the card-text area.
  final String text;

  static const Set<String> keys = <String>{'title', 'text'};
}

/// All eight endings, looked up by meter and direction.
class EndingSet {
  const EndingSet(this._byKey);

  final Map<String, Ending> _byKey;

  static String keyFor(MeterKind meter, MeterBound bound) =>
      '${meter.name}.${bound.name}';

  Ending lookup(MeterKind meter, MeterBound bound) {
    final Ending? ending = _byKey[keyFor(meter, bound)];
    if (ending == null) {
      throw StateError('No ending for ${keyFor(meter, bound)}');
    }
    return ending;
  }

  Iterable<Ending> get all => _byKey.values;

  int get length => _byKey.length;
}
