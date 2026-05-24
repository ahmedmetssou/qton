import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/history_item.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
    (_) => HistoryRepositoryImpl());

final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<HistoryItem>>(
        HistoryNotifier.new);

class HistoryNotifier extends AsyncNotifier<List<HistoryItem>> {
  HistoryRepository get _repo => ref.read(historyRepositoryProvider);

  @override
  Future<List<HistoryItem>> build() => _repo.getHistory();

  Future<void> record({
    required String storyId,
    required String storyTitle,
    required String coverSeed,
    required int chapterNumber,
    required int pageIndex,
    required int totalChapters,
  }) async {
    await _repo.addOrUpdateHistory(HistoryItem(
      storyId: storyId,
      storyTitle: storyTitle,
      coverSeed: coverSeed,
      lastChapter: chapterNumber,
      lastPage: pageIndex,
      totalChapters: totalChapters,
      readAt: DateTime.now(),
    ));
    state = AsyncValue.data(await _repo.getHistory());
  }

  Future<void> remove(String storyId) async {
    await _repo.removeFromHistory(storyId);
    state = AsyncValue.data(await _repo.getHistory());
  }

  Future<void> clear() async {
    await _repo.clearHistory();
    state = const AsyncValue.data([]);
  }
}
