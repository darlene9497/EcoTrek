import 'package:flutter/material.dart';

class EcoScoreWidget extends StatelessWidget {
  final dynamic user;
  const EcoScoreWidget({Key? key, this.user}) : super(key: key);

  int computeLevel(int xp) => (xp / 500).floor() + 1;

  String getLevelTitle(int level) {
    switch (level) {
      case 1:
        return "Seedling";
      case 2:
        return "Eco Explorer";
      case 3:
        return "Green Guardian";
      case 4:
        return "Planet Hero";
      default:
        return "EcoWarrior";
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalPoints = user?.totalPoints ?? 0;
    final int level = computeLevel(totalPoints);
    final String levelTitle = getLevelTitle(level);
    final int pointsToNextLevel = level * 500;
    final double progress = (totalPoints / pointsToNextLevel).clamp(0.0, 1.0);

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.eco, color: Colors.green.shade700, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Eco Score',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Level $level',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      levelTitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '$totalPoints XP / $pointsToNextLevel XP',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                color: Colors.green,
                backgroundColor: Colors.green.shade100,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            if (progress == 1.0)
              Text(
                "You're ready to level up 🎉",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              )
          ],
        ),
      ),
    );
  }
}
