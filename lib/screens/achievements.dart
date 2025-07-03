import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/challenge_model.dart';

class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final user = provider.currentUser;
          final challenges = provider.challenges;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final completed = user.completedChallenges.reversed.toList();
          if (completed.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No achievements yet. Complete challenges to earn achievements!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completed.length,
            itemBuilder: (context, index) {
              final challengeId = completed[index];
              final challenge = challenges.firstWhere(
                (c) => c.id == challengeId,
                orElse: () => ChallengeModel(
                  id: '',
                  title: 'Unknown Challenge',
                  description: '',
                  instructions: '',
                  difficulty: ChallengeDifficulty.easy,
                  category: ChallengeCategory.energy,
                  points: 0,
                  estimatedTime: 0,
                  createdAt: DateTime.now(),
                  createdBy: '',
                  aiGenerated: false,
                ),
              );
              if (challenge.id.isEmpty) {
                return const SizedBox.shrink();
              }
              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.emoji_events, color: Colors.amber.shade700),
                  title: Text(challenge.title),
                  subtitle: Text('Completed!'),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 