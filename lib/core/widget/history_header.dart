import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget {
  final int recordCount;

  const HistoryHeader({super.key, required this.recordCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Attendance History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (recordCount > 0)
            Text(
              '$recordCount records',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
