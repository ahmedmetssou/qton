import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
    (_) => FavoritesRepositoryImpl());

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<String>>(
        FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<String>> {
  FavoritesRepository get _repo => ref.read(favoritesRepositoryProvider);

  @override
  Future<List<String>> build() => _repo.getFavorites();

  Future<void> toggle(String storyId) async {
    final current = state.valueOrNull ?? [];
    if (current.contains(storyId)) {
      await _repo.removeFavorite(storyId);
    } else {
      await _repo.addFavorite(storyId);
    }
    state = AsyncValue.data(await _repo.getFavorites());
  }

  bool isFavorite(String storyId) {
    final list = state.valueOrNull ?? [];
    return list.contains(storyId);
  }
}
