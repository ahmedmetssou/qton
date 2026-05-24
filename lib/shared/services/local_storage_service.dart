import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/manga.dart';
import '../models/chapter.dart';
import '../../core/constants/app_constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('Override in ProviderScope'),
);

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // ─── Onboarding ─────────────────────────────────────────────────────────

  bool get hasSeenOnboarding =>
      _prefs.getBool(AppConstants.keyOnboardingSeen) ?? false;

  Future<void> setOnboardingSeen() =>
      _prefs.setBool(AppConstants.keyOnboardingSeen, true);

  // ─── Favourites ──────────────────────────────────────────────────────────

  List<Manga> getFavorites() {
    final raw = _prefs.getString(AppConstants.keyFavorites);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Manga.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveFavorites(List<Manga> mangas) {
    final encoded = jsonEncode(mangas.map((m) => m.toJson()).toList());
    return _prefs.setString(AppConstants.keyFavorites, encoded);
  }

  bool isFavorite(String mangaId) =>
      getFavorites().any((m) => m.id == mangaId);

  // ─── Reading History ─────────────────────────────────────────────────────

  List<ReadingProgress> getHistory() {
    final raw = _prefs.getString(AppConstants.keyHistory);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => ReadingProgress.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveHistory(List<ReadingProgress> history) {
    final encoded = jsonEncode(history.map((h) => h.toJson()).toList());
    return _prefs.setString(AppConstants.keyHistory, encoded);
  }

  Future<void> upsertProgress(ReadingProgress progress) async {
    final history = getHistory();
    final idx = history.indexWhere((h) => h.mangaId == progress.mangaId);
    if (idx >= 0) {
      history[idx] = progress;
    } else {
      history.insert(0, progress);
    }
    // Keep max 50 entries
    if (history.length > 50) history.removeRange(50, history.length);
    await saveHistory(history);
  }

  ReadingProgress? getProgressFor(String mangaId) {
    try {
      return getHistory().firstWhere((h) => h.mangaId == mangaId);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearHistory() => _prefs.remove(AppConstants.keyHistory);
}
