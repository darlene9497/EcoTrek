import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EcoTrek',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your daily green mission awaits',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _ecoScoreCard(),
            _challengeCard(),
            _quickStats(),
            _leaderboardCard(),
          ],
        ),
      ),
    );
  }

  Widget _ecoScoreCard() => Card(
        color: const Color(0xFFF2F8F2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Eco-Score',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '60%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: 0.6,
                color: Colors.green,
                backgroundColor: Colors.green.shade100,
              ),
              const SizedBox(height: 6),
              const Text(
                'Level 3: Eco Explorer',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );

  Widget _challengeCard() => Card(
        color: const Color(0xFFE6F4EA),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Challenge",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text('Carry a reusable water bottle all day 💧'),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF8ECAE6),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {},
                child: const Text('Mark as Done'),
              )
            ],
          ),
        ),
      );

  Widget _quickStats() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _statCard('Total Points', '1,250'),
            const SizedBox(width: 8),
            _statCard('Challenges Done', '15'),
          ],
        ),
      );

  Widget _statCard(String title, String value) => Expanded(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _leaderboardCard() => Card(
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leaderboard',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                'You are ranked #8 in your region 🌍',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              )
            ],
          ),
        ),
      );
}
