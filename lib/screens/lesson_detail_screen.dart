import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/lesson_model.dart';
import '../models/challenge_model.dart';
import '../providers/app_provider.dart';

class LessonDetailScreen extends StatelessWidget {
  final LessonModel lesson;

  const LessonDetailScreen({Key? key, required this.lesson}) : super(key: key);

  // Function to clean markdown formatting from AI responses
  String _cleanMarkdownText(String text) {
    return text
      .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1') // Remove **bold**
      .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1')     // Remove *italic*
      .replaceAll(RegExp(r'__([^_]+)__'), r'$1')     // Remove __bold__
      .replaceAll(RegExp(r'_([^_]+)_'), r'$1')       // Remove _italic_
      .replaceAll(RegExp(r'#{1,6}\s*'), '')          // Remove headers
      .replaceAll(RegExp(r'`([^`]+)`'), r'$1')       // Remove `code`
      .replaceAll(RegExp(r'```[^`]*```'), '')        // Remove code blocks
      .trim();
  }

  // Updated method to handle both ChallengeCategory and String
  Widget _buildAssetImage(dynamic category) {
    ChallengeCategory categoryEnum;
    
    if (category is ChallengeCategory) {
      categoryEnum = category;
    } else if (category is String) {
      categoryEnum = _parseCategory(category);
    } else {
      categoryEnum = ChallengeCategory.energy; // Default fallback
    }

    final imagePath = ChallengeModel.getCategoryStyles()[categoryEnum]?.imagePath ?? 'assets/images/categories/default.jpg';
    
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Final fallback - use gradient background
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green[400]!,
                Colors.green[600]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        );
      },
    );
  }

  ChallengeCategory _parseCategory(String category) {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isBookmarked = Provider.of<AppProvider>(context).currentUser?.bookmarkedLessons.contains(lesson.id) ?? false;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with Hero Image
          SliverAppBar(
            expandedHeight: screenHeight * 0.35,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lesson.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Show the image from lesson or fallback to asset
                  Builder(
                    builder: (context) {
                      if (lesson.imageUrl != null && lesson.imageUrl!.isNotEmpty) {
                        return Image.network(
                          lesson.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildAssetImage(lesson.category);
                          },
                        );
                      } else {
                        return _buildAssetImage(lesson.category);
                      }
                    },
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    // Title and Description
                    Text(
                      lesson.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.green[700],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lesson.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Key Points Section
                    if (lesson.keyPoints.isNotEmpty) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green[400]!, Colors.green[600]!],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.checklist_rtl,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Key Points',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      ...lesson.keyPoints.asMap().entries.map((entry) {
                        final index = entry.key;
                        final point = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.green.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.green[400]!, Colors.green[600]!],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  point,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      const SizedBox(height: 32),
                    ],
                    
                    // Lesson Content Section
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[400]!, Colors.green[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.article_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Lesson Content',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _cleanMarkdownText(lesson.content),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await Provider.of<AppProvider>(context, listen: false).toggleBookmark(lesson.id);
                            },
                            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
                            label: Text(isBookmarked ? 'Bookmarked' : 'Bookmark'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isBookmarked ? Colors.green[600] : Colors.green[100],
                              foregroundColor: isBookmarked ? Colors.white : Colors.green[700],
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add share functionality
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}