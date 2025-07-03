import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/challenge_model.dart';
import '../widgets/challenge_card_widget.dart';
import '../widgets/challenge_filter_widget.dart';

class EnhancedChallengesScreen extends StatefulWidget {
  @override
  _EnhancedChallengesScreenState createState() => _EnhancedChallengesScreenState();
}

class _EnhancedChallengesScreenState extends State<EnhancedChallengesScreen>
    with SingleTickerProviderStateMixin {
  ChallengeCategory? _selectedCategory;
  ChallengeDifficulty? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.initialize();
    });
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generatePersonalizedChallenge,
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'AI Challenge',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                          const SizedBox(height: 16),
                          Text('Error loading challenges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade600)),
                          const SizedBox(height: 8),
                          Text(provider.error!, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: () => provider.initialize(), child: const Text('Retry')),
                        ],
                      ),
                    );
                  }

                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: _buildTabBar(),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildAllChallenges(),
                              _buildCompletedChallenges(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Challenges', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showFilterDialog,
                icon: const Icon(Icons.filter_list),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade700,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('All'))),
          Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Completed'))),
        ],
      ),
    );
  }

  Widget _buildAllChallenges() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final allChallenges = provider.challenges.where((challenge) {
          final matchesCategory = _selectedCategory == null || challenge.category == _selectedCategory;
          final matchesDifficulty = _selectedDifficulty == null || challenge.difficulty == _selectedDifficulty;
          return matchesCategory && matchesDifficulty;
        }).toList();

        if (allChallenges.isEmpty) {
          return _buildEmptyState('No challenges found', 'Try adjusting your filters or check back later', Icons.search_off);
        }

        return RefreshIndicator(
          onRefresh: () async => await provider.initialize(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allChallenges.length,
            itemBuilder: (context, index) {
              final challenge = allChallenges[index];
              final isCompleted = provider.currentUser?.completedChallenges.contains(challenge.id) ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChallengeCardWidget(
                  challenge: challenge,
                  isCompleted: isCompleted,
                  onComplete: isCompleted ? null : () => _completeChallenge(challenge.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedChallenges() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.currentUser == null) {
          return _buildEmptyState('Please sign in', 'Sign in to view your completed challenges', Icons.login);
        }

        final completedChallenges = provider.challenges.where((challenge) => provider.currentUser!.completedChallenges.contains(challenge.id)).toList();

        if (completedChallenges.isEmpty) {
          return _buildEmptyState('No completed challenges yet', 'Start completing challenges to see them here', Icons.emoji_events_outlined);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: completedChallenges.length,
          itemBuilder: (context, index) {
            final challenge = completedChallenges[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChallengeCardWidget(
                challenge: challenge,
                isCompleted: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => ChallengeFilterWidget(
        selectedCategory: _selectedCategory,
        selectedDifficulty: _selectedDifficulty,
        onFilterChanged: (category, difficulty) {
          setState(() {
            _selectedCategory = category;
            _selectedDifficulty = difficulty;
          });
        },
      ),
    );
  }

  void _generatePersonalizedChallenge() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating personalized challenge...'),
        backgroundColor: Colors.green,
      ),
    );

    try {
      await provider.generatePersonalizedChallenge();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New challenge generated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate challenge: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _completeChallenge(String challengeId) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    try {
      await provider.completeChallenge(challengeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Challenge completed! Points added to your account.'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete challenge: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
