import '../../domain/entities/story.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/local_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final LocalDataSource _dataSource;

  StoryRepositoryImpl(this._dataSource);

  @override
  Future<List<Story>> getAllStories() => _dataSource.getStories();

  @override
  Future<List<Story>> getStoriesByGenre(String genre) async {
    final stories = await _dataSource.getStories();
    return stories.where((s) => s.genre.contains(genre)).toList();
  }

  @override
  Future<List<Story>> searchStories(String query) async {
    if (query.trim().isEmpty) return _dataSource.getStories();
    final stories = await _dataSource.getStories();
    final q = query.toLowerCase();
    return stories.where((s) {
      return s.title.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q) ||
          s.tags.any((t) => t.toLowerCase().contains(q)) ||
          s.genre.any((g) => g.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Future<Story?> getStoryById(String id) async {
    final stories = await _dataSource.getStories();
    try {
      return stories.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Chapter>> getChaptersForStory(String storyId) async {
    final chapters = await _dataSource.getChapters();
    return chapters
        .where((c) => c.storyId == storyId)
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));
  }

  @override
  Future<Chapter?> getChapterById(String chapterId) async {
    final chapters = await _dataSource.getChapters();
    try {
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (_) {
      return null;
    }
  }
}
