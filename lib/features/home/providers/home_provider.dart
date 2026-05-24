import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/manga.dart';
import '../../../shared/services/mock_api_service.dart';

class HomeState {
  final List<Manga> trending;
  final List<Manga> latest;
  final List<Manga> newArrivals;
  final List<Manga> allManga;

  const HomeState({
    required this.trending,
    required this.latest,
    required this.newArrivals,
    required this.allManga,
  });
}

class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final api = MockApiService.instance;
    final results = await Future.wait([
      api.fetchTrending(),
      api.fetchLatest(),
      api.fetchNew(),
      api.fetchAll(),
    ]);
    return HomeState(
      trending: results[0],
      latest: results[1],
      newArrivals: results[2],
      allManga: results[3],
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
