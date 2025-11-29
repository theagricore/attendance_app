import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:dartz/dartz.dart';

class GetAttendanceRecordsUsecase {
  final AttendanceRepository repository;

  GetAttendanceRecordsUsecase(this.repository);

  Future<Either<String, List<AttendanceRecord>>> call(String shopId) {
    return repository.getAttendanceRecords(shopId);
  }
}