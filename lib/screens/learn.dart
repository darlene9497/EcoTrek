import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  final List<Map<String, String>> lessons = [
    {
      'title': 'Why Recycling Matters',
      'desc': 'Understand the impact of proper waste separation and recycling.'
    },
    {
      'title': 'Carbon Footprint Explained',
      'desc': 'Learn how daily actions influence your environmental impact.'
    },
    {
      'title': 'How Solar Energy Works',
      'desc': 'Discover how solar power helps communities go green.'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            ...lessons.map((lesson) => Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson['title'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lesson['desc'] ?? '',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Start Lesson →',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}