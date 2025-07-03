import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ChallengeDifficulty { easy, medium, hard }

enum ChallengeCategory { 
  energy, 
  transport, 
  waste, 
  water, 
  food, 
  lifestyle,
  // New categories
  gardening,
  shopping,
  digitalLife,
  community,
  clothing,
  health,
  education,
  biodiversity,
  climate,
  recycling
}

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String instructions;
  final ChallengeDifficulty difficulty;
  final ChallengeCategory category;
  final int points;
  final int estimatedTime; // in minutes
  final List<String> tips;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final bool aiGenerated;
  final String createdBy;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructions,
    required this.difficulty,
    required this.category,
    required this.points,
    required this.estimatedTime,
    this.tips = const [],
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    required this.aiGenerated,
    required this.createdBy,
  });

  // Category styling and assets
  static Map<ChallengeCategory, CategoryStyle> getCategoryStyles() {
    return {
      ChallengeCategory.energy: CategoryStyle(
        colors: [const Color(0xFFFFB74D), const Color(0xFFFF9800)],
        icon: Icons.bolt,
        emoji: '⚡',
        imagePath: 'assets/images/categories/energy.jpg',
      ),
      ChallengeCategory.transport: CategoryStyle(
        colors: [const Color(0xFF64B5F6), const Color(0xFF2196F3)],
        icon: Icons.directions_car,
        emoji: '🚗',
        imagePath: 'assets/images/categories/transport.jpg',
      ),
      ChallengeCategory.waste: CategoryStyle(
        colors: [const Color(0xFF81C784), const Color(0xFF4CAF50)],
        icon: Icons.delete_outline,
        emoji: '♻️',
        imagePath: 'assets/images/categories/waste.jpg',
      ),
      ChallengeCategory.water: CategoryStyle(
        colors: [const Color(0xFF4FC3F7), const Color(0xFF00BCD4)],
        icon: Icons.water_drop,
        emoji: '💧',
        imagePath: 'assets/images/categories/water.jpg',
      ),
      ChallengeCategory.food: CategoryStyle(
        colors: [const Color(0xFFA5D6A7), const Color(0xFF66BB6A)],
        icon: Icons.restaurant,
        emoji: '🥗',
        imagePath: 'assets/images/categories/food.jpg',
      ),
      ChallengeCategory.lifestyle: CategoryStyle(
        colors: [const Color(0xFFBA68C8), const Color(0xFF9C27B0)],
        icon: Icons.favorite,
        emoji: '🌱',
        imagePath: 'assets/images/categories/lifestyle.jpg',
      ),
      ChallengeCategory.gardening: CategoryStyle(
        colors: [const Color(0xFF8BC34A), const Color(0xFF689F38)],
        icon: Icons.yard,
        emoji: '🌿',
        imagePath: 'assets/images/categories/gardening.jpg',
      ),
      ChallengeCategory.shopping: CategoryStyle(
        colors: [const Color(0xFFFF8A65), const Color(0xFFFF5722)],
        icon: Icons.shopping_bag,
        emoji: '🛍️',
        imagePath: 'assets/images/categories/shopping.jpg',
      ),
      ChallengeCategory.digitalLife: CategoryStyle(
        colors: [const Color(0xFF7986CB), const Color(0xFF3F51B5)],
        icon: Icons.smartphone,
        emoji: '📱',
        imagePath: 'assets/images/categories/digital.jpg',
      ),
      ChallengeCategory.community: CategoryStyle(
        colors: [const Color(0xFFFFB74D), const Color(0xFFF57C00)],
        icon: Icons.group,
        emoji: '👥',
        imagePath: 'assets/images/categories/community.jpg',
      ),
      ChallengeCategory.clothing: CategoryStyle(
        colors: [const Color(0xFFAD6A8F), const Color(0xFF8E24AA)],
        icon: Icons.checkroom,
        emoji: '👕',
        imagePath: 'assets/images/categories/clothing.jpg',
      ),
      ChallengeCategory.health: CategoryStyle(
        colors: [const Color(0xFF66BB6A), const Color(0xFF43A047)],
        icon: Icons.health_and_safety,
        emoji: '🏃',
        imagePath: 'assets/images/categories/health.jpg',
      ),
      ChallengeCategory.education: CategoryStyle(
        colors: [const Color(0xFF42A5F5), const Color(0xFF1976D2)],
        icon: Icons.school,
        emoji: '📚',
        imagePath: 'assets/images/categories/education.jpg',
      ),
      ChallengeCategory.biodiversity: CategoryStyle(
        colors: [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
        icon: Icons.pets,
        emoji: '🦋',
        imagePath: 'assets/images/categories/biodiversity.jpg',
      ),
      ChallengeCategory.climate: CategoryStyle(
        colors: [const Color(0xFF29B6F6), const Color(0xFF0288D1)],
        icon: Icons.cloud,
        emoji: '🌍',
        imagePath: 'assets/images/categories/climate.jpg',
      ),
      ChallengeCategory.recycling: CategoryStyle(
        colors: [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
        icon: Icons.recycling,
        emoji: '♻️',
        imagePath: 'assets/images/categories/recycling.jpg',
      ),
    };
  }

  // Get category display name
  static String getCategoryDisplayName(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.energy:
        return 'Energy';
      case ChallengeCategory.transport:
        return 'Transport';
      case ChallengeCategory.waste:
        return 'Waste Management';
      case ChallengeCategory.water:
        return 'Water Conservation';
      case ChallengeCategory.food:
        return 'Sustainable Food';
      case ChallengeCategory.lifestyle:
        return 'Green Lifestyle';
      case ChallengeCategory.gardening:
        return 'Eco Gardening';
      case ChallengeCategory.shopping:
        return 'Conscious Shopping';
      case ChallengeCategory.digitalLife:
        return 'Digital Sustainability';
      case ChallengeCategory.community:
        return 'Community Action';
      case ChallengeCategory.clothing:
        return 'Sustainable Fashion';
      case ChallengeCategory.health:
        return 'Green Health';
      case ChallengeCategory.education:
        return 'Eco Education';
      case ChallengeCategory.biodiversity:
        return 'Biodiversity';
      case ChallengeCategory.climate:
        return 'Climate Action';
      case ChallengeCategory.recycling:
        return 'Recycling & Upcycling';
    }
  }

  // Get category style
  CategoryStyle get categoryStyle => getCategoryStyles()[category]!;

  factory ChallengeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return ChallengeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      instructions: data['instructions'] ?? '',
      difficulty: _parseDifficulty(data['difficulty']),
      category: _parseCategory(data['category']),
      points: data['points'] ?? 0,
      estimatedTime: data['estimatedTime'] ?? 0,
      tips: List<String>.from(data['tips'] ?? []),
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: _parseDateTime(data['createdAt']),
      aiGenerated: _parseBoolean(data['aiGenerated']),
      createdBy: data['createdBy'] ?? '',
    );
  }

  // Helper method to parse difficulty - handles both string and int
  static ChallengeDifficulty _parseDifficulty(dynamic difficulty) {
    if (difficulty == null) return ChallengeDifficulty.easy;
    
    if (difficulty is String) {
      switch (difficulty.toLowerCase()) {
        case 'easy':
          return ChallengeDifficulty.easy;
        case 'medium':
          return ChallengeDifficulty.medium;
        case 'hard':
          return ChallengeDifficulty.hard;
        default:
          return ChallengeDifficulty.easy;
      }
    } else if (difficulty is int) {
      if (difficulty >= 0 && difficulty < ChallengeDifficulty.values.length) {
        return ChallengeDifficulty.values[difficulty];
      }
    }
    return ChallengeDifficulty.easy;
  }

  // Helper method to parse category - handles both string and int
  static ChallengeCategory _parseCategory(dynamic category) {
    if (category == null) return ChallengeCategory.energy;
    
    if (category is String) {
      switch (category.toLowerCase()) {
        case 'energy':
          return ChallengeCategory.energy;
        case 'transport':
          return ChallengeCategory.transport;
        case 'waste':
          return ChallengeCategory.waste;
        case 'water':
          return ChallengeCategory.water;
        case 'food':
          return ChallengeCategory.food;
        case 'lifestyle':
          return ChallengeCategory.lifestyle;
        case 'gardening':
          return ChallengeCategory.gardening;
        case 'shopping':
          return ChallengeCategory.shopping;
        case 'digitallife':
          return ChallengeCategory.digitalLife;
        case 'community':
          return ChallengeCategory.community;
        case 'clothing':
          return ChallengeCategory.clothing;
        case 'health':
          return ChallengeCategory.health;
        case 'education':
          return ChallengeCategory.education;
        case 'biodiversity':
          return ChallengeCategory.biodiversity;
        case 'climate':
          return ChallengeCategory.climate;
        case 'recycling':
          return ChallengeCategory.recycling;
        default:
          return ChallengeCategory.energy;
      }
    } else if (category is int) {
      if (category >= 0 && category < ChallengeCategory.values.length) {
        return ChallengeCategory.values[category];
      }
    }
    return ChallengeCategory.energy;
  }

  // Helper method to parse DateTime
  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    
    if (dateTime is Timestamp) {
      return dateTime.toDate();
    } else if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // Helper method to parse boolean
  static bool _parseBoolean(dynamic value) {
    if (value == null) return false;
    
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    
    return false;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'instructions': instructions,
      'difficulty': difficulty.name,
      'category': category.name,
      'points': points,
      'estimatedTime': estimatedTime,
      'tips': tips,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'aiGenerated': aiGenerated,
      'createdBy': createdBy,
    };
  }
}

// Category styling class
class CategoryStyle {
  final List<Color> colors;
  final IconData icon;
  final String emoji;
  final String imagePath;

  CategoryStyle({
    required this.colors,
    required this.icon,
    required this.emoji,
    required this.imagePath,
  });
}