import '../../core/constants/app_constants.dart';

class Story {
  final String id;
  final String title;
  final String description;
  final List<String> genre;
  final String coverSeed;
  final String accentColor;
  final double rating;
  final int views;
  final int chaptersCount;
  final String author;
  final String status;
  final List<String> tags;
  final bool isTrending;
  final bool isFeatured;
  final String releasedAt;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.coverSeed,
    required this.accentColor,
    required this.rating,
    required this.views,
    required this.chaptersCount,
    required this.author,
    required this.status,
    required this.tags,
    required this.isTrending,
    required this.isFeatured,
    required this.releasedAt,
  });

  String get coverUrl => AppConstants.coverUrl(coverSeed);

  String get formattedViews {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(0)}K';
    return views.toString();
  }
}
