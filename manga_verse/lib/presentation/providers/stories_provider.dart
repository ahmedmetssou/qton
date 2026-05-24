import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/repositories/story_repository.dart';

final localDataSourceProvider = Provider<LocalDataSource>((_) => LocalDataSource());

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(ref.read(localDataSourceProvider));
});

// All stories
final storiesProvider =
    AsyncNotifierProvider<StoriesNotifier, List<Story>>(StoriesNotifier.new);

class StoriesNotifier extends AsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    final repo = ref.read(storyRepositoryProvider);
    return repo.getAllStories();
  }
}

// All chapters
final allChaptersProvider =
    AsyncNotifierProvider<AllChaptersNotifier, List<Chapter>>(
        AllChaptersNotifier.new);

class AllChaptersNotifier extends AsyncNotifier<List<Chapter>> {
  @override
  Future<List<Chapter>> build() async {
    final ds = ref.read(localDataSourceProvider);
    return ds.getChapters();
  }
}

// Active filter + search
final categoryFilterProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

// Derived: filtered stories
final filteredStoriesProvider = Provider<AsyncValue<List<Story>>>((ref) {
  final storiesAsync = ref.watch(storiesProvider);
  final category = ref.watch(categoryFilterProvider);
  final query = ref.watch(searchQueryProvider);

  return storiesAsync.when(
    data: (stories) {
      var result = stories;
      if (category != null) {
        result = result.where((s) => s.genre.contains(category)).toList();
      }
      if (query.trim().isNotEmpty) {
        final q = query.toLowerCase();
        result = result
            .where((s) =>
                s.title.toLowerCase().contains(q) ||
                s.description.toLowerCase().contains(q) ||
                s.tags.any((t) => t.toLowerCase().contains(q)))
            .toList();
      }
      return AsyncValue.data(result);
    },
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

// Trending stories
final trendingStoriesProvider = Provider<AsyncValue<List<Story>>>((ref) {
  return ref.watch(storiesProvider).when(
        data: (s) => AsyncValue.data(s.where((x) => x.isTrending).toList()),
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
      );
});

// Featured story (for banner)
final featuredStoryProvider = Provider<AsyncValue<Story?>>((ref) {
  return ref.watch(storiesProvider).when(
        data: (stories) {
          try {
            return AsyncValue.data(stories.firstWhere((s) => s.isFeatured));
          } catch (_) {
            return AsyncValue.data(stories.isNotEmpty ? stories.first : null);
          }
        },
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
      );
});

// Chapters for a specific story
final chaptersForStoryProvider =
    Provider.family<AsyncValue<List<Chapter>>, String>((ref, storyId) {
  return ref.watch(allChaptersProvider).when(
        data: (all) {
          final chapters = all
              .where((c) => c.storyId == storyId)
              .toList()
            ..sort((a, b) => a.number.compareTo(b.number));
          return AsyncValue.data(chapters);
        },
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
      );
});

// Single chapter by ID
final chapterByIdProvider =
    Provider.family<AsyncValue<Chapter?>, String>((ref, chapterId) {
  return ref.watch(allChaptersProvider).when(
        data: (all) {
          try {
            return AsyncValue.data(all.firstWhere((c) => c.id == chapterId));
          } catch (_) {
            return const AsyncValue.data(null);
          }
        },
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
      );
});

// Single story by ID
final storyByIdProvider =
    Provider.family<AsyncValue<Story?>, String>((ref, storyId) {
  return ref.watch(storiesProvider).when(
        data: (all) {
          try {
            return AsyncValue.data(all.firstWhere((s) => s.id == storyId));
          } catch (_) {
            return const AsyncValue.data(null);
          }
        },
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
      );
});
