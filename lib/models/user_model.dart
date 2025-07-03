import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String avatar;
  final int ecoScore;
  final int totalPoints;
  final int level;
  final String levelTitle;
  final List<String> completedChallenges;
  final Map<String, dynamic> carbonFootprint;
  final DateTime createdAt;
  final DateTime lastActive;
  final List<String> bookmarkedLessons;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatar = '',
    this.ecoScore = 0,
    this.totalPoints = 0,
    this.level = 1,
    this.levelTitle = 'Eco Beginner',
    this.completedChallenges = const [],
    this.carbonFootprint = const {},
    required this.createdAt,
    required this.lastActive,
    this.bookmarkedLessons = const [],
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      avatar: data['avatar'] ?? '',
      ecoScore: data['ecoScore'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      level: data['level'] ?? 1,
      levelTitle: data['levelTitle'] ?? 'Eco Beginner',
      completedChallenges: List<String>.from(data['completedChallenges'] ?? []),
      carbonFootprint: data['carbonFootprint'] ?? {},
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      bookmarkedLessons: List<String>.from(data['bookmarkedLessons'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'avatar': avatar,
      'ecoScore': ecoScore,
      'totalPoints': totalPoints,
      'level': level,
      'levelTitle': levelTitle,
      'completedChallenges': completedChallenges,
      'carbonFootprint': carbonFootprint,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'bookmarkedLessons': bookmarkedLessons,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? avatar,
    int? ecoScore,
    int? totalPoints,
    int? level,
    String? levelTitle,
    List<String>? completedChallenges,
    Map<String, dynamic>? carbonFootprint,
    DateTime? lastActive,
    List<String>? bookmarkedLessons,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      ecoScore: ecoScore ?? this.ecoScore,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      carbonFootprint: carbonFootprint ?? this.carbonFootprint,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
      bookmarkedLessons: bookmarkedLessons ?? this.bookmarkedLessons,
    );
  }
}