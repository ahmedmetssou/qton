import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chapter.dart';
import '../services/local_storage_service.dart';

class HistoryNotifier extends Notifier<List<ReadingProgress>> {
  @override
  List<ReadingProgress> build() {
    final storage = ref.read(localStorageServiceProvider);
    return storage.getHistory();
  }

  Future<void> record(ReadingProgress progress) async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.upsertProgress(progress);
    state = storage.getHistory();
  }

  Future<void> clearAll() async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.clearHistory();
    state = [];
  }

  ReadingProgress? progressFor(String mangaId) {
    try {
      return state.firstWhere((h) => h.mangaId == mangaId);
    } catch (_) {
      return null;
    }
  }
}

final historyProvider =
    NotifierProvider<HistoryNotifier, List<ReadingProgress>>(
  HistoryNotifier.new,
);
