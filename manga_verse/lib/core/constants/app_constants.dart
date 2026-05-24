class AppConstants {
  static const String appName = 'MangaVerse';

  static const String storiesAssetPath = 'assets/data/stories.json';
  static const String chaptersAssetPath = 'assets/data/chapters.json';

  static const String favoritesBox = 'favorites_box';
  static const String historyBox = 'history_box';
  static const String progressBox = 'progress_box';
  static const String settingsBox = 'settings_box';

  static const String onboardingKey = 'onboarding_shown';
  static const String favoritesKey = 'favorites';
  static const String historyKey = 'history';
  static const String progressKey = 'progress';

  static const List<String> genres = [
    'Action',
    'Romance',
    'Fantasy',
    'Horror',
    'Comedy',
    'Sci-Fi',
    'Sports',
    'Supernatural',
    'Mystery',
    'Slice of Life',
  ];

  static String coverUrl(String seed) =>
      'https://picsum.photos/seed/mv_cover_$seed/400/600';

  static String pageUrl(String storyId, int chapterNum, int pageNum) =>
      'https://picsum.photos/seed/mv_s${storyId}_c${chapterNum}_p$pageNum/750/1200';
}
