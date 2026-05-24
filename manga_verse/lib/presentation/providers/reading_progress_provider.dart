import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

final readingProgressProvider =
    NotifierProvider<ReadingProgressNotifier, Map<String, int>>(
        ReadingProgressNotifier.new);

class ReadingProgressNotifier extends Notifier<Map<String, int>> {
  Box get _box => Hive.box(AppConstants.progressBox);

  @override
  Map<String, int> build() {
    final raw = _box.get(AppConstants.progressKey);
    if (raw == null) return {};
    return Map<String, int>.from(raw as Map);
  }

  void saveProgress(String chapterId, int pageIndex) {
    final next = {...state, chapterId: pageIndex};
    state = next;
    _box.put(AppConstants.progressKey, next);
  }

  int getProgress(String chapterId) => state[chapterId] ?? 0;
}
