import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/challenge_model.dart';
import '../models/lesson_model.dart';

class AIService {
  static const String _functionUrl = 'https://06df4902-3f95-4b35-8f90-e0cf9840429d-00-1sorrvagdwl7u.riker.replit.dev'; // Replace with your Replit URL

  static Future<ChallengeModel> generatePersonalizedChallenge({
    required String userId,
    required List<ChallengeCategory> preferredCategories,
    required ChallengeDifficulty difficulty,
    required Map<String, dynamic> userHabits,
    required String createdBy,
  }) async {
    final prompt = '''
    Generate a personalized eco-friendly challenge for a user with the following profile:
    - Preferred categories: ${preferredCategories.map((e) => e.name).join(', ')}
    - Difficulty level: ${difficulty.name}
    - Current habits: ${userHabits.toString()}

    Please create a challenge that is:
    1. Specific and actionable
    2. Appropriate for the difficulty level
    3. Relevant to their habits and preferences
    4. Includes clear instructions and tips

    Return ONLY a valid JSON object with these exact fields: title, description, instructions, category (use one of the preferred categories), points, estimatedTime, tips (array of strings).

    Example format:
    {
      "title": "Week-long Water Conservation Challenge",
      "description": "Reduce your daily water usage by implementing simple conservation techniques",
      "instructions": "Track your water usage daily and implement at least 3 water-saving techniques",
      "category": "water",
      "points": 25,
      "estimatedTime": 45,
      "tips": ["Take shorter showers", "Fix leaky faucets", "Collect rainwater"]
    }
    ''';

    try {
      final response = await http.post(
        Uri.parse('$_functionUrl/generateChallenge'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String cleanJson = data['challenge'].toString().trim();

        if (cleanJson.startsWith('```json')) {
          cleanJson = cleanJson.substring(7);
        }
        if (cleanJson.startsWith('```')) {
          cleanJson = cleanJson.substring(3);
        }
        if (cleanJson.endsWith('```')) {
          cleanJson = cleanJson.substring(0, cleanJson.length - 3);
        }

        final challengeData = json.decode(cleanJson);

        return ChallengeModel(
          id: '',
          title: challengeData['title'],
          description: challengeData['description'],
          instructions: challengeData['instructions'],
          difficulty: difficulty,
          category: ChallengeCategory.values.firstWhere(
            (cat) => cat.name.toLowerCase() == challengeData['category'].toString().toLowerCase(),
            orElse: () => preferredCategories.first,
          ),
          points: challengeData['points'] ?? _getPointsForDifficulty(difficulty),
          estimatedTime: challengeData['estimatedTime'] ?? 30,
          tips: List<String>.from(challengeData['tips'] ?? []),
          createdAt: DateTime.now(),
          aiGenerated: true,
          createdBy: createdBy,
        );
      } else {
        throw Exception('Failed to generate challenge: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate challenge: $e');
    }
  }

  static int _getPointsForDifficulty(ChallengeDifficulty difficulty) {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return 10;
      case ChallengeDifficulty.medium:
        return 25;
      case ChallengeDifficulty.hard:
        return 50;
    }
  }

  static Future<String> generateEcoQuote() async {
    const prompt = '''
    Provide a single inspiring eco-friendly quote (with author) to motivate sustainable behavior. 
    Return only the quote and author in one line like this:
    “Quote here.” – Author Name
    ''';

    final response = await http.post(
      Uri.parse('$_functionUrl/generateChallenge'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String cleanText = data['challenge'].toString().trim();
      if (cleanText.startsWith('```')) cleanText = cleanText.substring(3);
      if (cleanText.endsWith('```')) cleanText = cleanText.substring(0, cleanText.length - 3);
      return cleanText;
    } else {
      throw Exception('Failed to generate quote: ${response.body}');
    }
  }

  static Future<LessonModel> generateLesson({
    required ChallengeCategory category,
    required String topic,
    String? userLevel,
  }) async {
    final prompt = '''
    Create an educational microlearning lesson about $topic in the ${category.name} category.
    Target level: ${userLevel ?? 'beginner'}

    The lesson should be:
    1. Engaging and easy to understand
    2. 3-5 minutes reading time
    3. Include practical tips and actionable advice
    4. Have 3-5 key takeaway points
    5. Include a simple quiz with 3 questions

    Return ONLY a valid JSON object with these exact fields: title, description, content, keyPoints (array of strings), quiz (array of objects with question, options (array of 4 strings), correctAnswer (number 0-3), explanation).

    Example format:
    {
      "title": "Water Conservation Basics",
      "description": "Learn simple ways to save water at home",
      "content": "Water is a precious resource...",
      "keyPoints": ["Point 1", "Point 2", "Point 3"],
      "quiz": [
        {
          "question": "What percentage of Earth's water is freshwater?",
          "options": ["50%", "25%", "3%", "10%"],
          "correctAnswer": 2,
          "explanation": "Only about 3% of Earth's water is freshwater."
        }
      ]
    }
    ''';

    final response = await http.post(
      Uri.parse('$_functionUrl/generateChallenge'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String cleanJson = data['challenge'].toString().trim();
      if (cleanJson.startsWith('```json')) cleanJson = cleanJson.substring(7);
      if (cleanJson.startsWith('```')) cleanJson = cleanJson.substring(3);
      if (cleanJson.endsWith('```')) cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      final lessonData = json.decode(cleanJson);

      return LessonModel(
        id: '',
        title: lessonData['title'],
        description: lessonData['description'],
        content: lessonData['content'],
        type: LessonType.article,
        category: category,
        estimatedReadTime: 5,
        keyPoints: List<String>.from(lessonData['keyPoints'] ?? []),
        quiz: (lessonData['quiz'] as List? ?? []).map((q) => QuizQuestion.fromMap(q)).toList(),
        createdAt: DateTime.now(),
        aiGenerated: {
          'prompt': prompt,
          'generatedAt': DateTime.now().toIso8601String(),
          'version': '1.0',
          'model': 'gemini-1.5-flash',
        },
      );
    } else {
      throw Exception('Failed to generate lesson: ${response.body}');
    }
  }
}
