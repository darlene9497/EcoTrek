import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/challenge_model.dart';
import '../models/lesson_model.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';

class AppProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<ChallengeModel> _challenges = [];
  List<LessonModel> _lessons = [];
  List<UserModel> _leaderboard = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  List<ChallengeModel> get challenges => _challenges;
  List<LessonModel> get lessons => _lessons;
  List<UserModel> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int _determineLevel(int points) {
    if (points >= 1500) return 4;
    if (points >= 1000) return 3;
    if (points >= 500) return 2;
    return 1;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Initialize app data
  Future<void> initialize() async {
    _setLoading(true);
    _setError(null);
    try {
      User? user = FirebaseService.currentUser;
      if (user != null) {
        await _loadUserData(user.uid);
      }
      await _loadChallenges();
      await _loadLessons();
      await _loadLeaderboard();
    } catch (e) {
      print('[AppProvider] Initialize error: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      _currentUser = await FirebaseService.getUser(userId);
      notifyListeners();
    } catch (e) {
      print('[AppProvider] Load user error: $e');
    }
  }

  Future<void> _loadChallenges() async {
    try {
      print('[AppProvider] Loading challenges...');
      _challenges = await FirebaseService.getChallenges();
      for (var challenge in _challenges) {
        print('[AppProvider] Challenge: ${challenge.title}, AI: ${challenge.aiGenerated}');
      }
      notifyListeners();
    } catch (e) {
      print('[AppProvider] Load challenges error: $e');
      _setError('Failed to load challenges: $e');
    }
  }

  Future<void> _loadLessons() async {
    try {
      _lessons = await FirebaseService.getLessons();
      notifyListeners();
    } catch (e) {
      print('[AppProvider] Load lessons error: $e');
    }
  }

  Future<void> _loadLeaderboard() async {
    try {
      _leaderboard = await FirebaseService.getLeaderboard();
      notifyListeners();
    } catch (e) {
      print('[AppProvider] Load leaderboard error: $e');
    }
  }

  Future<void> completeChallenge(String challengeId) async {
    if (_currentUser == null) {
      _setError('Please sign in to complete challenges');
      return;
    }
    try {
      ChallengeModel challenge = _challenges.firstWhere((c) => c.id == challengeId);
      await FirebaseService.completeChallenge(
        _currentUser!.id,
        challengeId,
        challenge.points,
      );
      final updatedPoints = _currentUser!.totalPoints + challenge.points;
      _currentUser = _currentUser!.copyWith(
        totalPoints: updatedPoints,
        completedChallenges: [..._currentUser!.completedChallenges, challengeId],
        lastActive: DateTime.now(),
        level: _determineLevel(updatedPoints),
      );
      notifyListeners();
    } catch (e) {
      print('[AppProvider] Complete challenge error: $e');
      _setError('Failed to complete challenge: $e');
    }
  }

  Future<void> generatePersonalizedChallenge() async {
    if (_currentUser == null) {
      _setError('Please sign in to generate personalized challenges');
      return;
    }
    _setLoading(true);
    _setError(null);
    try {
      ChallengeModel challenge = await AIService.generatePersonalizedChallenge(
        userId: _currentUser!.id,
        preferredCategories: ChallengeCategory.values,
        difficulty: ChallengeDifficulty.medium,
        userHabits: _currentUser!.carbonFootprint,
        createdBy: _currentUser!.id,
      );
      await FirebaseService.createChallenge(challenge);
      await _loadChallenges();
    } catch (e) {
      print('[AppProvider] Generate challenge error: $e');
      _setError('Failed to generate challenge: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateLesson(ChallengeCategory category, String topic) async {
    _setLoading(true);
    _setError(null);
    try {
      LessonModel lesson = await AIService.generateLesson(
        category: category,
        topic: topic,
        userLevel: _currentUser?.levelTitle,
      );
      lesson = lesson.copyWith(createdBy: _currentUser?.id);
      await FirebaseService.createLesson(lesson);
      await _loadLessons();
    } catch (e) {
      print('[AppProvider] Generate lesson error: $e');
      _setError('Failed to generate lesson: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      UserCredential result = await FirebaseService.signInWithEmailAndPassword(email, password);
      await _loadUserData(result.user!.uid);
      await initialize();
      return true;
    } catch (e) {
      print('[AppProvider] Sign in error: $e');
      _setError('Sign in failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password, String username) async {
    _setLoading(true);
    _setError(null);
    try {
      UserCredential result = await FirebaseService.createUserWithEmailAndPassword(email, password);
      UserModel newUser = UserModel(
        id: result.user!.uid,
        username: username,
        email: email,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
      await FirebaseService.createUser(newUser);
      _currentUser = newUser;
      await initialize();
      return true;
    } catch (e) {
      print('[AppProvider] Sign up error: $e');
      _setError('Sign up failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseService.signOut();
      _currentUser = null;
      _challenges = [];
      _lessons = [];
      _leaderboard = [];
      _error = null;
      notifyListeners();
    } catch (e) {
      print('[AppProvider] Sign out error: $e');
      _setError('Sign out failed: $e');
    }
  }

  Future<void> toggleBookmark(String lessonId) async {
  if (_currentUser == null) return;
  final isBookmarked = _currentUser!.bookmarkedLessons.contains(lessonId);

  if (isBookmarked) {
    await FirebaseService.unbookmarkLesson(_currentUser!.id, lessonId);
    _currentUser = _currentUser!.copyWith(
      bookmarkedLessons: _currentUser!.bookmarkedLessons.where((id) => id != lessonId).toList(),
    );
  } else {
    await FirebaseService.bookmarkLesson(_currentUser!.id, lessonId);
    _currentUser = _currentUser!.copyWith(
      bookmarkedLessons: [..._currentUser!.bookmarkedLessons, lessonId],
    );
  }

  notifyListeners();
}


  void clearError() {
    _error = null;
    notifyListeners();
  }
}
