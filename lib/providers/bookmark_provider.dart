import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider with ChangeNotifier {
  List<String> _bookmarkedLessonIds = [];

  List<String> get bookmarkedLessonIds => _bookmarkedLessonIds;

  BookmarkProvider() {
    loadBookmarks();
  }

  // Load bookmarked IDs from SharedPreferences
  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarkedLessonIds = prefs.getStringList('bookmarkedLessons') ?? [];
    notifyListeners();
  }

  // Save bookmarks to SharedPreferences
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarkedLessons', _bookmarkedLessonIds);
  }

  // Toggle bookmark
  Future<void> toggleBookmark(String lessonId) async {
    if (_bookmarkedLessonIds.contains(lessonId)) {
      _bookmarkedLessonIds.remove(lessonId);
    } else {
      _bookmarkedLessonIds.add(lessonId);
    }
    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(String lessonId) {
    return _bookmarkedLessonIds.contains(lessonId);
  }
}
