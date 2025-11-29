import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/core/widget/selfie_photos_section.dart';
import 'package:attendance/core/widget/time_records_section.dart';
import 'package:attendance/core/widget/attendance_header.dart';
import 'package:flutter/material.dart';
import 'package:attendance/data/models/attendance_model.dart';

class AttendanceHistoryDetailScreen extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceHistoryDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        backgroundColor: AppColors.zPrimaryColor,
        foregroundColor: AppColors.zWhite,
        title: const Text(
          'Attendance Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AttendanceHeader(record: record),
            const SizedBox(height: 20),
            TimeRecordsSection(record: record),
            const SizedBox(height: 16),
            SelfiePhotosSection(record: record),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
