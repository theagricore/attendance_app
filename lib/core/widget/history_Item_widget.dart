import 'package:attendance/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:attendance/data/models/attendance_model.dart';

class HistoryItem extends StatelessWidget {
  final AttendanceRecord record;
  final VoidCallback onTap;

  const HistoryItem({super.key, required this.record, required this.onTap});

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  String _formatTime(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isOngoing = record.punchOutTime == null;

    return Material(
      color: AppColors.zWhite,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              // timeline circle
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isOngoing
                          ? Colors.orange.withOpacity(0.12)
                          : Colors.green.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isOngoing ? Icons.timelapse : Icons.check,
                      color: isOngoing ? AppColors.zOrande : AppColors.zGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(record.punchInTime),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.login, size: 14, color: AppColors.zGreen),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(record.punchInTime),
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 16),
                        if (record.punchOutTime != null) ...[
                          Icon(Icons.logout, size: 14, color: AppColors.zPrimaryColor),
                          const SizedBox(width: 6),
                          Text(
                            _formatTime(record.punchOutTime!),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // right info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isOngoing
                          ? Colors.orange.withOpacity(0.08)
                          : Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isOngoing ? 'In Progress' : 'Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isOngoing
                            ? Colors.orange.shade800
                            : Colors.green.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (record.punchOutTime != null)
                    Text(
                      record.formattedWorkingHours,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
