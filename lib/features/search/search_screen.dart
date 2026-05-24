import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/error_view.dart';
import '../../shared/services/mock_api_service.dart';
import '../home/widgets/manga_card.dart';
import 'providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchProvider.notifier).search(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final genres = MockApiService.instance.allGenres;

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          onChanged: _onChanged,
          autofocus: false,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search manga, author, genre...',
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppConstants.textSecondary),
            suffixIcon: searchState.query.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _textController.clear();
                      ref.read(searchProvider.notifier).clear();
                    },
                    child: const Icon(Icons.close_rounded,
                        color: AppConstants.textSecondary),
                  )
                : null,
            border: InputBorder.none,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
              height: 1, color: AppConstants.dividerColor, thickness: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Genre filter chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: genres.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  final isSelected = searchState.selectedGenre == null;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: isSelected,
                      onSelected: (_) => ref
                          .read(searchProvider.notifier)
                          .filterByGenre(null),
                      selectedColor: AppConstants.accentRed.withOpacity(0.2),
                      checkmarkColor: AppConstants.accentRed,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppConstants.accentRed
                            : AppConstants.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                final genre = genres[i - 1];
                final isSelected = searchState.selectedGenre == genre;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (_) => ref
                        .read(searchProvider.notifier)
                        .filterByGenre(isSelected ? null : genre),
                    selectedColor: AppConstants.accentRed.withOpacity(0.2),
                    checkmarkColor: AppConstants.accentRed,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppConstants.accentRed
                          : AppConstants.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),

          Divider(height: 1, color: AppConstants.dividerColor),

          // Results
          Expanded(
            child: _buildResults(searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppConstants.accentRed),
      );
    }

    if (state.query.isEmpty && state.selectedGenre == null) {
      return _EmptyPrompt();
    }

    if (state.results.isEmpty) {
      return EmptyView(
        title: 'No results found',
        subtitle: state.selectedGenre != null
            ? 'No manga in "${state.selectedGenre}" genre yet.'
            : 'Try a different title, author, or genre.',
        icon: Icons.search_off_rounded,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: state.results.length,
      itemBuilder: (context, i) =>
          MangaGridCard(manga: state.results[i]),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _EmptyPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.manage_search_rounded,
              size: 72, color: AppConstants.textSecondary),
          const SizedBox(height: 16),
          const Text(
            'Discover Your Next Obsession',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search by title, author or\nselect a genre above',
            style: TextStyle(
              fontSize: 13,
              color: AppConstants.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
    );
  }
}
