import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/chapter.dart';
import '../../../shared/models/manga.dart';
import '../../../shared/providers/history_provider.dart';
import '../../../shared/services/mock_api_service.dart';

class ReaderState {
  final Manga manga;
  final Chapter chapter;
  final List<Chapter> allChapters;
  final bool showControls;
  final double scrollProgress;

  const ReaderState({
    required this.manga,
    required this.chapter,
    required this.allChapters,
    this.showControls = true,
    this.scrollProgress = 0,
  });

  ReaderState copyWith({
    Manga? manga,
    Chapter? chapter,
    List<Chapter>? allChapters,
    bool? showControls,
    double? scrollProgress,
  }) =>
      ReaderState(
        manga: manga ?? this.manga,
        chapter: chapter ?? this.chapter,
        allChapters: allChapters ?? this.allChapters,
        showControls: showControls ?? this.showControls,
        scrollProgress: scrollProgress ?? this.scrollProgress,
      );

  int get currentIndex =>
      allChapters.indexWhere((c) => c.id == chapter.id);

  Chapter? get nextChapter {
    final idx = currentIndex;
    if (idx > 0) return allChapters[idx - 1];
    return null;
  }

  Chapter? get prevChapter {
    final idx = currentIndex;
    if (idx < allChapters.length - 1) return allChapters[idx + 1];
    return null;
  }
}

/// Family arg is encoded as "$mangaId:$chapterId"
class ReaderNotifier extends FamilyAsyncNotifier<ReaderState, String> {
  @override
  Future<ReaderState> build(String key) async {
    final parts = key.split(':');
    final mangaId = parts[0];
    final chapterId = parts.sublist(1).join(':');

    final api = MockApiService.instance;
    final results = await Future.wait([
      api.fetchById(mangaId),
      api.fetchChapters(mangaId),
    ]);
    final manga = results[0] as Manga?;
    final chapters = results[1] as List<Chapter>;
    if (manga == null) throw Exception('Manga not found');
    final chapter = chapters.firstWhere(
      (c) => c.id == chapterId,
      orElse: () => chapters.first,
    );
    return ReaderState(manga: manga, chapter: chapter, allChapters: chapters);
  }

  void toggleControls() {
    final s = state.value;
    if (s == null) return;
    state = AsyncData(s.copyWith(showControls: !s.showControls));
  }

  void updateProgress(double progress) {
    final s = state.value;
    if (s == null) return;
    state = AsyncData(s.copyWith(scrollProgress: progress));
    ref.read(historyProvider.notifier).record(ReadingProgress(
          mangaId: s.manga.id,
          chapterId: s.chapter.id,
          chapterNumber: s.chapter.number,
          chapterTitle: s.chapter.title,
          mangaTitle: s.manga.title,
          mangaCover: s.manga.coverUrl,
          progress: progress,
          timestamp: DateTime.now(),
        ));
  }

  void goToChapter(Chapter chapter) {
    final s = state.value;
    if (s == null) return;
    state = AsyncData(s.copyWith(chapter: chapter, scrollProgress: 0));
  }
}

final readerProvider =
    AsyncNotifierProvider.family<ReaderNotifier, ReaderState, String>(
  ReaderNotifier.new,
);

/// Convenience helper to build the family key
String readerKey(String mangaId, String chapterId) => '$mangaId:$chapterId';
