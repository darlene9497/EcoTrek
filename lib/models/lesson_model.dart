import 'package:cloud_firestore/cloud_firestore.dart';
import 'challenge_model.dart';

enum LessonType { article, video, interactive, quiz }

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final LessonType type;
  final ChallengeCategory category;
  final int estimatedReadTime;
  final List<String> keyPoints;
  final String? videoUrl;
  final String? imageUrl;
  final List<QuizQuestion> quiz;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic>? aiGenerated;
  final String? createdBy;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.type,
    required this.category,
    required this.estimatedReadTime,
    this.keyPoints = const [],
    this.videoUrl,
    this.imageUrl,
    this.quiz = const [],
    this.isActive = true,
    required this.createdAt,
    this.aiGenerated,
    this.createdBy,
  });

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    LessonType? type,
    ChallengeCategory? category,
    int? estimatedReadTime,
    List<String>? keyPoints,
    String? videoUrl,
    String? imageUrl,
    List<QuizQuestion>? quiz,
    bool? isActive,
    DateTime? createdAt,
    Map<String, dynamic>? aiGenerated,
    String? createdBy,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      type: type ?? this.type,
      category: category ?? this.category,
      estimatedReadTime: estimatedReadTime ?? this.estimatedReadTime,
      keyPoints: keyPoints ?? this.keyPoints,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      quiz: quiz ?? this.quiz,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      aiGenerated: aiGenerated ?? this.aiGenerated,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LessonModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      type: LessonType.values[data['type'] ?? 0],
      category: ChallengeCategory.values[data['category'] ?? 0],
      estimatedReadTime: data['estimatedReadTime'] ?? 0,
      keyPoints: List<String>.from(data['keyPoints'] ?? []),
      videoUrl: data['videoUrl'],
      imageUrl: data['imageUrl'],
      quiz: (data['quiz'] as List? ?? [])
          .map((q) => QuizQuestion.fromMap(q))
          .toList(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      aiGenerated: data['aiGenerated'],
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'type': type.index,
      'category': category.index,
      'estimatedReadTime': estimatedReadTime,
      'keyPoints': keyPoints,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'quiz': quiz.map((q) => q.toMap()).toList(),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'aiGenerated': aiGenerated,
      'createdBy': createdBy,
    };
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? 0,
      explanation: map['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}