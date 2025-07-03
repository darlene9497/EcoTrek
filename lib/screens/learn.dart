import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'lesson_detail_screen.dart';

class LearnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.lessons.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final lessons = provider.lessons;
        final aiChallenges = provider.challenges.where((c) => c.aiGenerated != null && c.createdBy == provider.currentUser?.id).toList();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Microlearning',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
                if (aiChallenges.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final lastChallenge = aiChallenges.first;
                            await provider.generateLesson(lastChallenge.category, lastChallenge.title);
                          },
                    icon: const Icon(Icons.auto_stories),
                    label: const Text('Generate Lesson from Last AI Challenge'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                else
                  const Text('Generate an AI Challenge first to unlock personalized lessons!'),
                const SizedBox(height: 16),
                if (lessons.isEmpty)
                  const Text('No lessons available. Try generating a new lesson!'),
            ...lessons.map((lesson) => Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              lesson.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                              lesson.description,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonDetailScreen(lesson: lesson),
                              ),
                            );
                          },
                          child: const Text(
                            'Start Lesson →',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
        );
      },
    );
  }
}