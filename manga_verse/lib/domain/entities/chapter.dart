import '../../core/constants/app_constants.dart';

class Chapter {
  final String id;
  final String storyId;
  final int number;
  final String title;
  final int pagesCount;
  final String publishedAt;
  final bool isLocked;

  const Chapter({
    required this.id,
    required this.storyId,
    required this.number,
    required this.title,
    required this.pagesCount,
    required this.publishedAt,
    required this.isLocked,
  });

  String pageUrl(int pageNum) =>
      AppConstants.pageUrl(storyId, number, pageNum);
}
