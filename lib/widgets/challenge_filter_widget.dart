import 'package:flutter/material.dart';
import '../models/challenge_model.dart';

class ChallengeFilterWidget extends StatefulWidget {
  final ChallengeCategory? selectedCategory;
  final ChallengeDifficulty? selectedDifficulty;
  final void Function(ChallengeCategory?, ChallengeDifficulty?) onFilterChanged;

  const ChallengeFilterWidget({
    Key? key,
    this.selectedCategory,
    this.selectedDifficulty,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<ChallengeFilterWidget> createState() => _ChallengeFilterWidgetState();
}

class _ChallengeFilterWidgetState extends State<ChallengeFilterWidget> {
  ChallengeCategory? _category;
  ChallengeDifficulty? _difficulty;

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
    _difficulty = widget.selectedDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filter Challenges',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<ChallengeCategory>(
              value: _category,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.green.shade50,
              ),
              items: [
                const DropdownMenuItem<ChallengeCategory>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...ChallengeCategory.values.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
                    )),
              ],
              onChanged: (val) => setState(() => _category = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ChallengeDifficulty>(
              value: _difficulty,
              decoration: InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.green.shade50,
              ),
              items: [
                const DropdownMenuItem<ChallengeDifficulty>(
                  value: null,
                  child: Text('All Difficulties'),
                ),
                ...ChallengeDifficulty.values.map((diff) => DropdownMenuItem(
                      value: diff,
                      child: Text(diff.name[0].toUpperCase() + diff.name.substring(1)),
                    )),
              ],
              onChanged: (val) => setState(() => _difficulty = val),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _category = null;
                        _difficulty = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterChanged(_category, _difficulty);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 