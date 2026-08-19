import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flags.dart';

/// What one generation leaves the next: who is owed, and who is owed a
/// reckoning.
///
/// This is the *only* thing that survives a death, and the only thing that
/// survives the app closing. Meters, blood, played cards and ordinary run
/// flags all die with the father, by design.
@immutable
class Legacy {
  const Legacy({required this.enemies, required this.debts});

  static const Legacy empty = Legacy(enemies: <String>{}, debts: <String>{});

  final Set<String> enemies;
  final Set<String> debts;

  /// Which run flag creates which enemy.
  static const Map<String, String> enemyFromFlag = <String, String>{
    GameFlags.atWar: 'rival_family',
    GameFlags.commissionSnubbed: 'commission',
    GameFlags.fedStonewalled: 'feds',
    GameFlags.unionRefused: 'union',
  };

  /// Which run flag creates which debt.
  static const Map<String, String> debtFromFlag = <String, String>{
    GameFlags.copOnPayroll: 'detective',
    GameFlags.aldermanFunded: 'alderman',
    GameFlags.whaleForgiven: 'bookmaker',
    GameFlags.docksTaken: 'dock_bosses',
  };

  /// Derives a legacy from the flags one run actually set.
  ///
  /// Takes only the run's own flags. Inherited flags are deliberately not
  /// passed in, which is what stops memory chaining past one generation:
  /// the son inherits from his father, never from his grandfather.
  factory Legacy.fromRunFlags(Set<String> runFlags) {
    return Legacy(
      enemies: <String>{
        for (final MapEntry<String, String> e in enemyFromFlag.entries)
          if (runFlags.contains(e.key)) e.value,
      },
      debts: <String>{
        for (final MapEntry<String, String> e in debtFromFlag.entries)
          if (runFlags.contains(e.key)) e.value,
      },
    );
  }

  /// The inherited flags this legacy seeds into the heir's run.
  Set<String> get flags => <String>{
    for (final String e in enemies) 'enemy_$e',
    for (final String d in debts) 'debt_$d',
  };

  bool get isEmpty => enemies.isEmpty && debts.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is Legacy &&
      setEquals(other.enemies, enemies) &&
      setEquals(other.debts, debts);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(enemies),
    Object.hashAllUnordered(debts),
  );

  @override
  String toString() => 'Legacy(enemies: $enemies, debts: $debts)';
}

/// Where a [Legacy] is kept between runs.
abstract class LegacyStore {
  Future<Legacy> load();
  Future<void> save(Legacy legacy);
}

/// Session-only store, for tests and for anything that should not touch disk.
class InMemoryLegacyStore implements LegacyStore {
  InMemoryLegacyStore([this._legacy = Legacy.empty]);

  Legacy _legacy;

  @override
  Future<Legacy> load() async => _legacy;

  @override
  Future<void> save(Legacy legacy) async => _legacy = legacy;
}

/// Disk-backed store.
///
/// Two short string lists, which is exactly what shared_preferences is for.
/// Deliberately not a save-slot system and not a run history: there is one
/// legacy, it is overwritten on each death, and nothing else is kept.
class PrefsLegacyStore implements LegacyStore {
  const PrefsLegacyStore();

  static const String enemiesKey = 'legacy.enemies';
  static const String debtsKey = 'legacy.debts';

  @override
  Future<Legacy> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return Legacy(
        enemies: (prefs.getStringList(enemiesKey) ?? <String>[]).toSet(),
        debts: (prefs.getStringList(debtsKey) ?? <String>[]).toSet(),
      );
    } catch (error) {
      // A legacy that cannot be read is not worth crashing over; the heir
      // simply starts clean.
      debugPrint('Legacy load failed, starting clean: $error');
      return Legacy.empty;
    }
  }

  @override
  Future<void> save(Legacy legacy) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(enemiesKey, legacy.enemies.toList()..sort());
      await prefs.setStringList(debtsKey, legacy.debts.toList()..sort());
    } catch (error) {
      debugPrint('Legacy save failed: $error');
    }
  }
}
