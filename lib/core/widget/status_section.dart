import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusSection extends StatelessWidget {
  final DateTime? punchInTime;
  final DateTime? punchOutTime;

  const StatusSection({
    super.key,
    required this.punchInTime,
    required this.punchOutTime,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = punchOutTime != null;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Punch In: ${_formatTime(punchInTime)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                if (isCompleted)
                  Text(
                    'Punch Out: ${_formatTime(punchOutTime)}',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return 'N/A';
    return DateFormat('hh:mm a').format(time);
  }
}
