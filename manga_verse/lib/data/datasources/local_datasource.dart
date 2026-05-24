import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../models/story_model.dart';
import '../models/chapter_model.dart';

class LocalDataSource {
  List<StoryModel>? _cachedStories;
  List<ChapterModel>? _cachedChapters;

  Future<List<StoryModel>> getStories() async {
    if (_cachedStories != null) return _cachedStories!;
    final raw = await rootBundle.loadString(AppConstants.storiesAssetPath);
    final list = json.decode(raw) as List<dynamic>;
    _cachedStories =
        list.map((e) => StoryModel.fromJson(e as Map<String, dynamic>)).toList();
    return _cachedStories!;
  }

  Future<List<ChapterModel>> getChapters() async {
    if (_cachedChapters != null) return _cachedChapters!;
    final raw = await rootBundle.loadString(AppConstants.chaptersAssetPath);
    final list = json.decode(raw) as List<dynamic>;
    _cachedChapters = list
        .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cachedChapters!;
  }
}
