import 'dart:convert';

class HistoryItem {
  final String storyId;
  final String storyTitle;
  final String coverSeed;
  final int lastChapter;
  final int lastPage;
  final int totalChapters;
  final DateTime readAt;

  HistoryItem({
    required this.storyId,
    required this.storyTitle,
    required this.coverSeed,
    required this.lastChapter,
    required this.lastPage,
    required this.totalChapters,
    required this.readAt,
  });

  double get progress =>
      totalChapters > 0 ? (lastChapter - 1) / totalChapters : 0.0;

  Map<String, dynamic> toMap() => {
        'storyId': storyId,
        'storyTitle': storyTitle,
        'coverSeed': coverSeed,
        'lastChapter': lastChapter,
        'lastPage': lastPage,
        'totalChapters': totalChapters,
        'readAt': readAt.toIso8601String(),
      };

  factory HistoryItem.fromMap(Map<String, dynamic> map) => HistoryItem(
        storyId: map['storyId'] as String,
        storyTitle: map['storyTitle'] as String,
        coverSeed: map['coverSeed'] as String,
        lastChapter: map['lastChapter'] as int,
        lastPage: map['lastPage'] as int,
        totalChapters: map['totalChapters'] as int,
        readAt: DateTime.parse(map['readAt'] as String),
      );

  String toJson() => jsonEncode(toMap());

  factory HistoryItem.fromJson(String source) =>
      HistoryItem.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
