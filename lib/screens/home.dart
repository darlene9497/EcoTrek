import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../widgets/eco_score_widget.dart';
import '../widgets/challenge_card_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../models/challenge_model.dart';
import '../screens/carbon_tracker.dart';

class EnhancedHomeScreen extends StatefulWidget {
  @override
  _EnhancedHomeScreenState createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Provider.of<AppProvider>(context, listen: false).initialize(),
          child: Consumer<AppProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.currentUser == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(provider),
                    const SizedBox(height: 20),
                    EcoScoreWidget(user: provider.currentUser),
                    const SizedBox(height: 16),
                    _buildTodaysChallenge(provider),
                    const SizedBox(height: 16),
                    _buildQuickStats(provider),
                    const SizedBox(height: 16),
                    _buildCarbonFootprintChart(provider),
                    const SizedBox(height: 16),
                    QuickActionsWidget(),
                    const SizedBox(height: 16),
                    _buildRecentAchievements(provider),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    final user = provider.currentUser;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${user?.username ?? 'EcoWarrior'}! 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ready to make a difference today?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green.shade100,
          child: user?.avatar.isNotEmpty == true
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(user!.avatar, fit: BoxFit.cover),
                )
              : Text(
                  user?.username[0].toUpperCase() ?? 'E',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTodaysChallenge(AppProvider provider) {
    final challenges = provider.challenges.where((c) => 
        !provider.currentUser!.completedChallenges.contains(c.id)).toList();
    
    if (challenges.isEmpty) {
      return Card(
        color: const Color(0xFFE6F4EA),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("All challenges completed 🎉"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => provider.generatePersonalizedChallenge(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Generate New Challenge'),
              ),
            ],
          ),
        ),
      );
    }

    final todayChallenge = challenges.first;
    return ChallengeCardWidget(
      challenge: todayChallenge,
      onComplete: () => provider.completeChallenge(todayChallenge.id),
      isToday: true,
    );
  }

  Widget _buildQuickStats(AppProvider provider) {
    final user = provider.currentUser;
    return Row(
      children: [
        _buildStatCard(
          'Total Points',
          user?.totalPoints.toString() ?? '0',
          Icons.stars,
          Colors.amber,
        ),
        const SizedBox(width: 8),
        _buildStatCard(
          'Challenges',
          user?.completedChallenges.length.toString() ?? '0',
          Icons.emoji_events,
          Colors.green,
        ),
        const SizedBox(width: 8),
        _buildStatCard(
          'Level',
          ((user?.totalPoints ?? 0) ~/ 500 + 1).toString(),
          Icons.trending_up,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
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
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarbonFootprintChart(AppProvider provider) {
    final carbonData = provider.currentUser?.carbonFootprint ?? {};
    
    if (carbonData.isEmpty) {
      return Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Carbon Footprint',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.eco,
                      size: 48,
                      color: Colors.green.shade300,
                    ),
                    const SizedBox(height: 8),
                    const Text('Track your daily activities to see your impact'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<AppProvider>(context, listen: false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CarbonTrackerScreen(
                              userChallenges: provider.challenges,
                              completedIds: provider.currentUser?.completedChallenges ?? [],
                            ),
                          ),
                        );
                      },
                      child: const Text('Start Tracking'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carbon Footprint This Week',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(carbonData),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, dynamic> data) {
    final colors = [
      Colors.red.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
    ];

    int index = 0;
    return data.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      
      return PieChartSectionData(
        value: (entry.value as num).toDouble(),
        title: '${entry.key}\n${entry.value}kg',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildRecentAchievements(AppProvider provider) {
    final user = provider.currentUser;
    final challenges = provider.challenges;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final completed = user.completedChallenges.reversed.toList();
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/achievements'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (completed.isEmpty)
              const Text('No achievements yet. Complete challenges to earn achievements!'),
            ...completed.take(3).map((challengeId) {
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
              if (challenge.id.isEmpty) return const SizedBox.shrink();
              return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  Icons.eco,
                  color: Colors.green.shade700,
                ),
              ),
                title: Text(challenge.title),
                subtitle: const Text('Completed!'),
              trailing: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              );
            }),
          ],
        ),
      ),
    );
  }
}