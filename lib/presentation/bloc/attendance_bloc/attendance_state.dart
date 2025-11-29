part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class SelfieUploading extends AttendanceState {}

class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);
}

class AttendanceRecordAdded extends AttendanceState {
  final String message;

  AttendanceRecordAdded(this.message);
}

class TodayAttendanceLoaded extends AttendanceState {
  final AttendanceRecord? attendance;

  TodayAttendanceLoaded(this.attendance);
}

class AttendanceRecordUpdated extends AttendanceState {
  final String message;

  AttendanceRecordUpdated(this.message);
}

class AttendanceRecordsLoaded extends AttendanceState {
  final List<AttendanceRecord> records;

  AttendanceRecordsLoaded(this.records);
}

class SelfieImageUploaded extends AttendanceState {
  final String imageUrl;

  SelfieImageUploaded(this.imageUrl);
}