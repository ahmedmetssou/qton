abstract class FavoritesRepository {
  Future<List<String>> getFavorites();
  Future<void> addFavorite(String storyId);
  Future<void> removeFavorite(String storyId);
  bool isFavorite(String storyId, List<String> favorites);
}
