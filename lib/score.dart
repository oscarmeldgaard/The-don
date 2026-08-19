import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The longest reign the player has ever managed, in years.
///
/// Deliberately **not** part of [Legacy]. A legacy is what one father leaves
/// his son — enemies and debts, replaced wholesale on each death. The best
/// year is the opposite: it belongs to the player rather than the character,
/// it only ever climbs, and no card can read it. Folding it into Legacy would
/// have made "the only thing that survives a death" quietly untrue.
abstract class ScoreStore {
  Future<int> loadBestYear();
  Future<void> saveBestYear(int year);
}

/// Session-only store, for tests and for anything that should not touch disk.
class InMemoryScoreStore implements ScoreStore {
  InMemoryScoreStore([this._best = 0]);

  int _best;

  @override
  Future<int> loadBestYear() async => _best;

  @override
  Future<void> saveBestYear(int year) async => _best = year;
}

/// Disk-backed store. One integer.
class PrefsScoreStore implements ScoreStore {
  const PrefsScoreStore();

  static const String bestYearKey = 'score.bestYear';

  @override
  Future<int> loadBestYear() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(bestYearKey) ?? 0;
    } catch (error) {
      // A record that cannot be read is not worth crashing over; the player
      // simply has nothing to beat yet.
      debugPrint('Best year load failed, starting from nothing: $error');
      return 0;
    }
  }

  @override
  Future<void> saveBestYear(int year) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(bestYearKey, year);
    } catch (error) {
      debugPrint('Best year save failed: $error');
    }
  }
}
