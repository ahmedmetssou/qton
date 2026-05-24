import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/repositories/history_repository.dart';
import '../models/history_item.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  Box get _box => Hive.box(AppConstants.historyBox);

  @override
  Future<List<HistoryItem>> getHistory() async {
    final raw = _box.get(AppConstants.historyKey);
    if (raw == null) return [];
    return (raw as List)
        .map((e) => HistoryItem.fromJson(e as String))
        .toList();
  }

  Future<void> _save(List<HistoryItem> items) async {
    await _box.put(
      AppConstants.historyKey,
      items.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<void> addOrUpdateHistory(HistoryItem item) async {
    final history = await getHistory();
    history.removeWhere((h) => h.storyId == item.storyId);
    history.insert(0, item);
    if (history.length > 50) history.removeLast();
    await _save(history);
  }

  @override
  Future<void> removeFromHistory(String storyId) async {
    final history = await getHistory();
    history.removeWhere((h) => h.storyId == storyId);
    await _save(history);
  }

  @override
  Future<void> clearHistory() async {
    await _box.put(AppConstants.historyKey, <String>[]);
  }
}
