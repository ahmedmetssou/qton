import '../entities/story.dart';
import '../entities/chapter.dart';

abstract class StoryRepository {
  Future<List<Story>> getAllStories();
  Future<List<Story>> getStoriesByGenre(String genre);
  Future<List<Story>> searchStories(String query);
  Future<Story?> getStoryById(String id);
  Future<List<Chapter>> getChaptersForStory(String storyId);
  Future<Chapter?> getChapterById(String chapterId);
}
