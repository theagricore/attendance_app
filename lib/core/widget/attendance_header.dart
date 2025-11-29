import 'package:flutter/material.dart';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/core/theme/app_color.dart';

class AttendanceHeader extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceHeader({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.punchOutTime != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.zPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Shop name
          Text(
            record.shopName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.zWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isCompleted ? 'COMPLETED' : 'IN PROGRESS',
              style: const TextStyle(
                color: AppColors.zWhite,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Working hours
          if (isCompleted) _buildWorkingHours(),
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.zWhite,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Working Hours: ${record.formattedWorkingHours}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
