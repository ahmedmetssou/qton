import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  Box get _box => Hive.box(AppConstants.favoritesBox);

  @override
  Future<List<String>> getFavorites() async {
    final raw = _box.get(AppConstants.favoritesKey);
    if (raw == null) return [];
    return List<String>.from(raw as List);
  }

  @override
  Future<void> addFavorite(String storyId) async {
    final favs = await getFavorites();
    if (!favs.contains(storyId)) {
      favs.add(storyId);
      await _box.put(AppConstants.favoritesKey, favs);
    }
  }

  @override
  Future<void> removeFavorite(String storyId) async {
    final favs = await getFavorites();
    favs.remove(storyId);
    await _box.put(AppConstants.favoritesKey, favs);
  }

  @override
  bool isFavorite(String storyId, List<String> favorites) =>
      favorites.contains(storyId);
}
