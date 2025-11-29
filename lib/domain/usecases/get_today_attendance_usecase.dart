import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:dartz/dartz.dart';

class GetTodayAttendanceUsecase {
  final AttendanceRepository repository;

  GetTodayAttendanceUsecase(this.repository);

  Future<Either<String, AttendanceRecord?>> call(String shopId) {
    return repository.getTodayAttendance(shopId);
  }
}