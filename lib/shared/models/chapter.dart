class Chapter {
  final String id;
  final String mangaId;
  final int number;
  final String title;
  final List<String> pageUrls;
  final DateTime uploadedAt;
  final int views;

  const Chapter({
    required this.id,
    required this.mangaId,
    required this.number,
    required this.title,
    required this.pageUrls,
    required this.uploadedAt,
    required this.views,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json['id'] as String,
        mangaId: json['mangaId'] as String,
        number: json['number'] as int,
        title: json['title'] as String,
        pageUrls: List<String>.from(json['pageUrls'] as List),
        uploadedAt: DateTime.parse(json['uploadedAt'] as String),
        views: json['views'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mangaId': mangaId,
        'number': number,
        'title': title,
        'pageUrls': pageUrls,
        'uploadedAt': uploadedAt.toIso8601String(),
        'views': views,
      };

  String get displayTitle => 'Ep.$number: $title';
}

class ReadingProgress {
  final String mangaId;
  final String chapterId;
  final int chapterNumber;
  final String chapterTitle;
  final String mangaTitle;
  final String mangaCover;
  final double progress; // 0.0 to 1.0
  final DateTime timestamp;

  const ReadingProgress({
    required this.mangaId,
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.mangaTitle,
    required this.mangaCover,
    required this.progress,
    required this.timestamp,
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      ReadingProgress(
        mangaId: json['mangaId'] as String,
        chapterId: json['chapterId'] as String,
        chapterNumber: json['chapterNumber'] as int,
        chapterTitle: json['chapterTitle'] as String,
        mangaTitle: json['mangaTitle'] as String,
        mangaCover: json['mangaCover'] as String,
        progress: (json['progress'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'mangaId': mangaId,
        'chapterId': chapterId,
        'chapterNumber': chapterNumber,
        'chapterTitle': chapterTitle,
        'mangaTitle': mangaTitle,
        'mangaCover': mangaCover,
        'progress': progress,
        'timestamp': timestamp.toIso8601String(),
      };
}
