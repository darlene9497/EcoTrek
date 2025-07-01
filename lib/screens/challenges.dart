import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  final List<Map<String, String>> challenges = [
    {
      'title': 'Avoid single-use plastics',
      'icon': '🌱'
    },
    {
      'title': 'Walk or cycle instead of driving',
      'icon': '🚲'
    },
    {
      'title': 'Recycle household waste',
      'icon': '♻️'
    },
    {
      'title': 'Turn off lights when not needed',
      'icon': '💡'
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
              'Daily Challenges',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            ...challenges.map((challenge) => Card(
                  color: const Color(0xFFF2F8F2),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              challenge['icon'] ?? '',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                challenge['title'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF8ECAE6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Mark as Done'),
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