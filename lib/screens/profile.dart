import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../providers/bookmark_provider.dart';
import '../models/lesson_model.dart';
import '../services/ai_service.dart';
import '../screens/lesson_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String dailyQuote = '';
  List<LessonModel> allLessons = [];

  @override
  void initState() {
    super.initState();
    _loadOrGenerateQuote();
    _loadAllLessons();
  }

  Future<void> _loadOrGenerateQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString('quoteDate');

    if (savedDate == today) {
      setState(() => dailyQuote = prefs.getString('quoteText') ?? '');
    } else {
      try {
        final quote = await AIService.generateEcoQuote();
        setState(() => dailyQuote = quote);
        await prefs.setString('quoteDate', today);
        await prefs.setString('quoteText', quote);
      } catch (e) {
        setState(() => dailyQuote = 'The Earth is what we all have in common. – Wendell Berry');
      }
    }
  }

  Future<void> _loadAllLessons() async {
    // TODO: Replace with Firestore call or provider data
    // allLessons = await FirebaseService.getLessons();
    // For now use dummy data or empty
    setState(() {
      allLessons = []; // Replace this with real lessons from your app
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, BookmarkProvider>(
      builder: (context, appProvider, bookmarkProvider, child) {
        final user = appProvider.currentUser;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookmarkedLessons = appProvider.lessons.where(
          (lesson) => appProvider.currentUser?.bookmarkedLessons.contains(lesson.id) ?? false
        ).toList();


        final level = (user.totalPoints ~/ 500) + 1;
        final ecoScore = user.totalPoints;
        final nextLevelXP = level * 500;
        final previousLevelXP = (level - 1) * 500;
        final currentLevelXP = ecoScore - previousLevelXP;
        final levelXPRange = nextLevelXP - previousLevelXP;
        final progress = (currentLevelXP / levelXPRange).clamp(0.0, 1.0);

        final progressEmojiBar = () {
          const totalBlocks = 7;
          final filledBlocks = (progress * totalBlocks).round();
          return '🟩' * filledBlocks + '⬜' * (totalBlocks - filledBlocks);
        }();

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800])),
                const SizedBox(height: 16),

                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green.shade200,
                    child: Text(user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Text(user.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20)),
                        child: Text('Level $level', style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(height: 4),
                      Text(user.email, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Eco Progress', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('Level $level\n$progressEmojiBar  $currentLevelXP/$levelXPRange XP'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: progress, color: Colors.green, backgroundColor: Colors.greenAccent.shade100),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Eco Inspiration', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('“$dailyQuote”', style: const TextStyle(color: Colors.green, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Bookmarked Lessons
                if (bookmarkedLessons.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Bookmarked Lessons',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: bookmarkedLessons.map((lesson) {
                      return ListTile(
                        leading: lesson.imageUrl != null
                          ? Image.network(lesson.imageUrl!, width: 40, height: 40, fit: BoxFit.cover)
                          : const Icon(Icons.bookmark, color: Colors.green),
                        title: Text(lesson.title),
                        subtitle: Text(lesson.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LessonDetailScreen(lesson: lesson),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: appProvider.isLoading ? null : () async => await appProvider.signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
