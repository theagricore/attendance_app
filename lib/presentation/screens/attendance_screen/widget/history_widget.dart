import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/core/widget/history_Item_widget.dart';
import 'package:attendance/core/widget/history_header.dart';
import 'package:flutter/material.dart';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/presentation/screens/attendance_history_screen/attendance_history_detail_screen.dart';

class HistoryWidget extends StatelessWidget {
  final List<AttendanceRecord> attendanceHistory;

  const HistoryWidget({super.key, required this.attendanceHistory});

  void _navigateToDetail(BuildContext context, AttendanceRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceHistoryDetailScreen(record: record),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.zWhite,
        borderRadius: BorderRadius.circular(14),
        
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HistoryHeader(recordCount: attendanceHistory.length),
            const Divider(height: 1),
            SizedBox(
              height: 300, 
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                itemCount: attendanceHistory.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final record = attendanceHistory[index];
                  return HistoryItem(
                    record: record,
                    onTap: () => _navigateToDetail(context, record),
                  );
                },
              ),
            ),
            if (attendanceHistory.isEmpty)
              SizedBox(
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 48, color: AppColors.zGrey),
                      const SizedBox(height: 8),
                      Text(
                        'No records yet',
                        style: TextStyle(color: AppColors.zGrey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
