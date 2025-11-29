import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateAttendanceRecordUsecase {
  final AttendanceRepository repository;

  UpdateAttendanceRecordUsecase(this.repository);

  Future<Either<String, String>> call(AttendanceRecord record) {
    return repository.updateAttendanceRecord(record);
  }
}