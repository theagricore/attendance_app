part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class AddAttendanceRecordEvent extends AttendanceEvent {
  final AttendanceRecord record;

  AddAttendanceRecordEvent(this.record);
}

class GetTodayAttendanceEvent extends AttendanceEvent {
  final String shopId;

  GetTodayAttendanceEvent(this.shopId);
}

class UpdateAttendanceRecordEvent extends AttendanceEvent {
  final AttendanceRecord record;

  UpdateAttendanceRecordEvent(this.record);
}

class GetAttendanceRecordsEvent extends AttendanceEvent {
  final String shopId;

  GetAttendanceRecordsEvent(this.shopId);
}

class UploadSelfieImageEvent extends AttendanceEvent {
  final File imageFile;

  UploadSelfieImageEvent(this.imageFile);
}