class Manga {
  final String id;
  final String title;
  final String coverUrl;
  final String author;
  final List<String> genres;
  final String status; // Ongoing | Completed
  final double rating;
  final int views;
  final String description;
  final int chapterCount;
  final bool isTrending;
  final bool isNew;
  final DateTime updatedAt;

  const Manga({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.author,
    required this.genres,
    required this.status,
    required this.rating,
    required this.views,
    required this.description,
    required this.chapterCount,
    this.isTrending = false,
    this.isNew = false,
    required this.updatedAt,
  });

  factory Manga.fromJson(Map<String, dynamic> json) => Manga(
        id: json['id'] as String,
        title: json['title'] as String,
        coverUrl: json['coverUrl'] as String,
        author: json['author'] as String,
        genres: List<String>.from(json['genres'] as List),
        status: json['status'] as String,
        rating: (json['rating'] as num).toDouble(),
        views: json['views'] as int,
        description: json['description'] as String,
        chapterCount: json['chapterCount'] as int,
        isTrending: json['isTrending'] as bool? ?? false,
        isNew: json['isNew'] as bool? ?? false,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverUrl': coverUrl,
        'author': author,
        'genres': genres,
        'status': status,
        'rating': rating,
        'views': views,
        'description': description,
        'chapterCount': chapterCount,
        'isTrending': isTrending,
        'isNew': isNew,
        'updatedAt': updatedAt.toIso8601String(),
      };

  String get formattedViews {
    if (views >= 1000000) return '${(views / 1000000).toStringAsFixed(1)}M';
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(0)}K';
    return views.toString();
  }

  Manga copyWith({
    String? id,
    String? title,
    String? coverUrl,
    String? author,
    List<String>? genres,
    String? status,
    double? rating,
    int? views,
    String? description,
    int? chapterCount,
    bool? isTrending,
    bool? isNew,
    DateTime? updatedAt,
  }) =>
      Manga(
        id: id ?? this.id,
        title: title ?? this.title,
        coverUrl: coverUrl ?? this.coverUrl,
        author: author ?? this.author,
        genres: genres ?? this.genres,
        status: status ?? this.status,
        rating: rating ?? this.rating,
        views: views ?? this.views,
        description: description ?? this.description,
        chapterCount: chapterCount ?? this.chapterCount,
        isTrending: isTrending ?? this.isTrending,
        isNew: isNew ?? this.isNew,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
