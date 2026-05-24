import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/manga.dart';
import '../../../shared/models/chapter.dart';
import '../../../shared/services/mock_api_service.dart';

class MangaDetailState {
  final Manga manga;
  final List<Chapter> chapters;

  const MangaDetailState({required this.manga, required this.chapters});
}

class MangaDetailNotifier
    extends FamilyAsyncNotifier<MangaDetailState, String> {
  @override
  Future<MangaDetailState> build(String mangaId) async {
    final api = MockApiService.instance;
    final results = await Future.wait([
      api.fetchById(mangaId),
      api.fetchChapters(mangaId),
    ]);
    final manga = results[0] as Manga?;
    final chapters = results[1] as List<Chapter>;
    if (manga == null) throw Exception('Manga not found');
    return MangaDetailState(manga: manga, chapters: chapters);
  }
}

final mangaDetailProvider =
    AsyncNotifierProvider.family<MangaDetailNotifier, MangaDetailState, String>(
  MangaDetailNotifier.new,
);
