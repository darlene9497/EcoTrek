import 'package:flutter/material.dart';
import '../models/challenge_model.dart';

extension CategoryNameExtension on ChallengeCategory {
  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }
}

class CarbonTrackerScreen extends StatelessWidget {
  final List<ChallengeModel> userChallenges;
  final List<String> completedIds;

  const CarbonTrackerScreen({
    Key? key,
    required this.userChallenges,
    required this.completedIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedChallenges = userChallenges
        .where((c) => completedIds.contains(c.id))
        .toList();

    final groupedByCategory = <ChallengeCategory, List<ChallengeModel>>{};

    for (var c in completedChallenges) {
      groupedByCategory.putIfAbsent(c.category, () => []).add(c);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Tracker'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: completedChallenges.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No eco actions tracked yet.\nComplete challenges to start seeing your impact!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummaryCard(completedChallenges),
                const SizedBox(height: 16),
                ...groupedByCategory.entries.map((entry) {
                  final category = entry.key;
                  final challenges = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category: ${category.displayName}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...challenges.map((c) => Card(
                            color: Colors.white,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: const Icon(Icons.eco, color: Colors.green),
                              title: Text(c.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${c.points} pts • ${c.estimatedTime} mins'),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: c.points / 100,
                                    color: Colors.green,
                                    backgroundColor: Colors.green.shade100,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Saved ~${(c.points ~/ 5)}kg CO₂',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.check_circle, color: Colors.green),
                            ),
                          )),
                      const Divider(height: 32),
                    ],
                  );
                }).toList(),
              ],
            ),
    );
  }

  Widget _buildSummaryCard(List<ChallengeModel> completed) {
    final totalPoints = completed.fold(0, (sum, c) => sum + c.points);
    final totalTime = completed.fold(0, (sum, c) => sum + c.estimatedTime);
    final estimatedCO2 = completed.fold(0, (sum, c) => sum + (c.points ~/ 5));

    return Card(
      color: Colors.green.shade50,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '🌱 Your Eco Impact Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Points', '$totalPoints'),
                _buildStatColumn('Time', '$totalTime mins'),
                _buildStatColumn('CO₂ Saved', '$estimatedCO2 kg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
