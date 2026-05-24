import '../../domain/entities/story.dart';

class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.title,
    required super.description,
    required super.genre,
    required super.coverSeed,
    required super.accentColor,
    required super.rating,
    required super.views,
    required super.chaptersCount,
    required super.author,
    required super.status,
    required super.tags,
    required super.isTrending,
    required super.isFeatured,
    required super.releasedAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      genre: List<String>.from(json['genre'] as List),
      coverSeed: json['cover_seed'] as String,
      accentColor: json['accent_color'] as String,
      rating: (json['rating'] as num).toDouble(),
      views: json['views'] as int,
      chaptersCount: json['chapters_count'] as int,
      author: json['author'] as String,
      status: json['status'] as String,
      tags: List<String>.from(json['tags'] as List),
      isTrending: json['is_trending'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      releasedAt: json['released_at'] as String,
    );
  }
}
