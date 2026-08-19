/// Playtest instrumentation. **Two hooks, both inert unless switched on.**
///
/// The deck is finished and every remaining question about it is one a
/// simulation cannot answer — docs/content-bible.md closes tuning against the
/// greedy oracle for exactly that reason. What is left needs a person playing
/// the web build who cannot see the numbers, and a session run that way needs
/// two things the game did not have:
///
///  * **a trace**, because the session asks the player what they remember
///    *before* anybody looks at what actually happened. So the run has to be
///    recorded silently while it is played and read back only afterwards.
///    Showing it live would contaminate the one measurement worth taking.
///  * **a seed**, because the last run of the session is a seeded one that
///    deliberately delivers a six-beat burn. Under random play a burn is met in
///    a few runs per hundred, which is not something a session can wait for.
///
/// Both are off by default and neither changes a single value the player sees.
/// With no query parameters this file costs one null check per swipe.
///
/// On the web build they are switched on through the URL:
///
///     index.html?trace=1              record, print the run at each death
///     index.html?seed=1234&trace=1    deterministic draw, recorded
///
/// The trace is printed to the browser console, never to the screen: the
/// facilitator opens devtools after the session and copies it out, and the
/// player never sees a number at any point.
library;

import 'dart:convert';
import 'dart:math';

import 'card.dart';
import 'ending.dart';
import 'heir.dart';

/// How the two hooks were switched on for this session.
class PlaytestConfig {
  const PlaytestConfig({this.seed, this.trace = false, this.label});

  /// Fixed RNG seed, or null for a real (unseeded) run.
  final int? seed;

  /// Whether to record the run.
  final bool trace;

  /// Free text written into the trace header, so the seeded burn run can be
  /// told apart from the three unguided ones without guesswork.
  final String? label;

  static const PlaytestConfig off = PlaytestConfig();

  /// Reads the hooks off the URL. On a non-web build [Uri.base] carries no
  /// such parameters and this returns [off], which is the point: nothing has
  /// to be remembered or reverted before shipping.
  factory PlaytestConfig.fromUri(Uri uri) {
    final Map<String, String> q = uri.queryParameters;
    final String? rawSeed = q['seed'];
    final int? seed = rawSeed == null ? null : int.tryParse(rawSeed);
    final String? rawTrace = q['trace'];
    final bool trace = rawTrace == '1' || rawTrace == 'true';
    return PlaytestConfig(seed: seed, trace: trace, label: q['label']);
  }

  /// A seeded [Random], or null to let [GameState] make its own.
  Random? get random => seed == null ? null : Random(seed!);

  bool get isOn => seed != null || trace;

  @override
  String toString() =>
      'PlaytestConfig(seed: $seed, trace: $trace, '
      'label: $label)';
}

/// One swipe.
class TraceEntry {
  const TraceEntry({
    required this.swipe,
    required this.cardId,
    required this.speaker,
    required this.direction,
    required this.label,
    required this.chainId,
    required this.beat,
    required this.vice,
    required this.effects,
    required this.setFlags,
    required this.family,
    required this.commission,
    required this.cops,
    required this.cash,
    required this.blood,
  });

  final int swipe;
  final String cardId;
  final String speaker;

  /// 'left' or 'right'.
  final String direction;

  /// The label of the side taken — what the player actually read as they
  /// committed, which is the thing worth having when they say "I remember
  /// letting the old man have his Thursday".
  final String label;

  final String? chainId;
  final int? beat;
  final bool vice;

  /// The deltas applied, blood included.
  final Map<String, int> effects;
  final List<String> setFlags;

  /// Meters *after* the swipe.
  final int family;
  final int commission;
  final int cops;
  final int cash;
  final int blood;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'swipe': swipe,
    'card': cardId,
    'speaker': speaker,
    'dir': direction,
    'label': label,
    if (chainId != null) 'chain': chainId,
    if (beat != null) 'beat': beat,
    if (vice) 'vice': true,
    'effects': effects,
    if (setFlags.isNotEmpty) 'setFlags': setFlags,
    'after': <String, int>{
      'family': family,
      'commission': commission,
      'cops': cops,
      'cash': cash,
      'blood': blood,
    },
  };
}

/// One run, from the first card to the ending.
class RunRecord {
  RunRecord(this.run);

  final int run;
  final List<TraceEntry> swipes = <TraceEntry>[];

  String? endingId;
  String? endingTitle;
  String? heir;
  int? bloodAtDeath;

  /// Chains whose opener was seen, and the highest beat reached in each.
  final Map<String, int> chainsSeen = <String, int>{};

  int get length => swipes.length;
  int get vicesMet => swipes.where((TraceEntry e) => e.vice).length;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'run': run,
    'swipes': length,
    'ending': endingId,
    'endingTitle': endingTitle,
    'heir': heir,
    'bloodAtDeath': bloodAtDeath,
    'vicesMet': vicesMet,
    'chains': chainsSeen,
    'cards': swipes.map((TraceEntry e) => e.toJson()).toList(),
  };
}

/// The session: every run played in this browser tab, in order.
///
/// Deliberately dumb. It records and it prints; it draws no conclusions and it
/// is never read by the game.
class RunTrace {
  RunTrace({this.config = PlaytestConfig.off});

  final PlaytestConfig config;
  final List<RunRecord> runs = <RunRecord>[];

  RunRecord _current = RunRecord(1);

  RunRecord get current => _current;

  void record(TraceEntry entry, GameCard card) {
    _current.swipes.add(entry);
    final CardChain? chain = card.chain;
    if (chain != null) {
      final int seen = _current.chainsSeen[chain.id] ?? 0;
      if (chain.beat > seen) _current.chainsSeen[chain.id] = chain.beat;
    }
  }

  void endRun({Ending? ending, Heir? heir, required int blood}) {
    _current
      ..endingId = ending == null
          ? null
          : EndingSet.keyFor(ending.meter, ending.bound)
      ..endingTitle = ending?.title
      ..heir = heir?.kind.name
      ..bloodAtDeath = blood;
    runs.add(_current);
    _emit(_current);
  }

  void startRun(int run) {
    _current = RunRecord(run);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'seed': config.seed,
    'label': config.label,
    'runs': runs.map((RunRecord r) => r.toJson()).toList(),
  };

  String get json => const JsonEncoder.withIndent('  ').convert(toJson());

  /// One line per swipe. What a person actually reads when reconstructing
  /// "why did you let him have Thursday".
  String summarise(RunRecord r) {
    final StringBuffer b = StringBuffer()
      ..writeln(
        '--- run ${r.run}: ${r.length} swipes, '
        'ending ${r.endingTitle ?? '(alive)'}, '
        'heir ${r.heir ?? '-'}, blood ${r.bloodAtDeath}, '
        '${r.vicesMet} vices, chains ${r.chainsSeen}',
      );
    for (final TraceEntry e in r.swipes) {
      final String beat = e.chainId == null
          ? ''
          : '  [${e.chainId} b${e.beat}]';
      b.writeln(
        '  ${e.swipe.toString().padLeft(3)} '
        '${e.cardId}  ${e.speaker.padRight(14)} '
        '${e.direction.padRight(5)} ${e.label}'
        '${e.vice ? '  (vice)' : ''}$beat',
      );
    }
    return b.toString();
  }

  void _emit(RunRecord r) {
    if (!config.trace) return;
    // Console only. Never the screen: the session asks what the player
    // remembers before anyone looks at what happened.
    // ignore: avoid_print
    print(summarise(r));
    // ignore: avoid_print
    print('TRACE_JSON ${jsonEncode(r.toJson())}');
  }
}
