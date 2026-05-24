import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/manga.dart';
import '../../../shared/services/mock_api_service.dart';

class SearchState {
  final String query;
  final List<Manga> results;
  final bool isLoading;
  final String? selectedGenre;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.selectedGenre,
  });

  SearchState copyWith({
    String? query,
    List<Manga>? results,
    bool? isLoading,
    String? Function()? selectedGenre,
  }) =>
      SearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        isLoading: isLoading ?? this.isLoading,
        selectedGenre:
            selectedGenre != null ? selectedGenre() : this.selectedGenre,
      );
}

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  Future<void> search(String query) async {
    state = state.copyWith(query: query, isLoading: true);
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }
    final results = await MockApiService.instance.search(query);
    state = state.copyWith(results: results, isLoading: false);
  }

  Future<void> filterByGenre(String? genre) async {
    state = state.copyWith(
      selectedGenre: () => genre,
      isLoading: true,
    );
    if (genre == null) {
      if (state.query.isNotEmpty) {
        await search(state.query);
      } else {
        state = state.copyWith(results: [], isLoading: false);
      }
      return;
    }
    final results = await MockApiService.instance.fetchByGenre(genre);
    state = state.copyWith(results: results, isLoading: false);
  }

  void clear() {
    state = const SearchState();
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
