import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAction(context, Icons.local_florist, 'Plant Tree', Colors.green, () {}),
            _buildAction(context, Icons.water_drop, 'Save Water', Colors.blue, () {}),
            _buildAction(context, Icons.recycling, 'Recycle', Colors.orange, () {}),
            _buildAction(context, Icons.directions_bike, 'Bike', Colors.purple, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: color.withOpacity(0.1),
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
            iconSize: 32,
            splashRadius: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
} 