import '../../domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.storyId,
    required super.number,
    required super.title,
    required super.pagesCount,
    required super.publishedAt,
    required super.isLocked,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'].toString(),
      storyId: json['story_id'].toString(),
      number: json['number'] as int,
      title: json['title'] as String,
      pagesCount: json['pages_count'] as int,
      publishedAt: json['published_at'] as String,
      isLocked: json['is_locked'] as bool? ?? false,
    );
  }
}
