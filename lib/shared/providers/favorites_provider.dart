import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/manga.dart';
import '../services/local_storage_service.dart';

class FavoritesNotifier extends Notifier<List<Manga>> {
  @override
  List<Manga> build() {
    final storage = ref.read(localStorageServiceProvider);
    return storage.getFavorites();
  }

  void toggle(Manga manga) {
    final storage = ref.read(localStorageServiceProvider);
    final exists = state.any((m) => m.id == manga.id);
    if (exists) {
      state = state.where((m) => m.id != manga.id).toList();
    } else {
      state = [manga, ...state];
    }
    storage.saveFavorites(state);
  }

  bool isFavorite(String id) => state.any((m) => m.id == id);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Manga>>(
  FavoritesNotifier.new,
);
