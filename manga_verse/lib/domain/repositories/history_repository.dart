import '../../data/models/history_item.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistory();
  Future<void> addOrUpdateHistory(HistoryItem item);
  Future<void> removeFromHistory(String storyId);
  Future<void> clearHistory();
}
