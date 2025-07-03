import 'package:flutter/material.dart';

class ChallengeCardWidget extends StatelessWidget {
  final dynamic challenge;
  final VoidCallback? onComplete;
  final bool isCompleted;
  final bool isToday;
  final bool isAIGenerated;

  const ChallengeCardWidget({
    Key? key,
    required this.challenge,
    this.onComplete,
    this.isCompleted = false,
    this.isToday = false,
    this.isAIGenerated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isToday ? const Color(0xFFE6F4EA) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAIGenerated ? Icons.psychology : Icons.local_fire_department,
                  color: isAIGenerated ? Colors.purple : Colors.green.shade700,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    challenge.title ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                if (isToday)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Today', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description ?? '',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(challenge.category?.toString().split('.').last ?? ''),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: TextStyle(color: Colors.green.shade700),
                ),
                Chip(
                  label: Text('Points: ${challenge.points ?? 0}'),
                  backgroundColor: Colors.amber.shade50,
                  labelStyle: const TextStyle(color: Colors.amber),
                ),
                Chip(
                  label: Text('Difficulty: ${challenge.difficulty?.toString().split('.').last ?? ''}'),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            if (challenge.tips != null && challenge.tips.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ...List.generate(
                challenge.tips.length,
                (i) => Text('• ${challenge.tips[i]}', style: const TextStyle(color: Colors.black54)),
              ),
            ],
            if (!isCompleted && onComplete != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check),
                label: const Text('Mark as Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 