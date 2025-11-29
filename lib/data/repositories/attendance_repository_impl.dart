import 'package:attendance/data/datasources/firebase_attendance_service.dart';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:dartz/dartz.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final FirebaseAttendanceService _service = FirebaseAttendanceServiceImpl();

  @override
  Future<Either<String, String>> addShop(ShopModel shop) {
    return _service.addShop(shop);
  }

  @override
  Future<Either<String, List<ShopModel>>> getShops() {
    return _service.getShops();
  }

  @override
  Future<Either<String, String>> addAttendanceRecord(AttendanceRecord record) {
    return _service.addAttendanceRecord(record);
  }

  @override
  Future<Either<String, List<AttendanceRecord>>> getAttendanceRecords(String shopId) {
    return _service.getAttendanceRecords(shopId);
  }

  @override
  Future<Either<String, String>> updateAttendanceRecord(AttendanceRecord record) {
    return _service.updateAttendanceRecord(record);
  }

  @override
  Future<Either<String, AttendanceRecord?>> getTodayAttendance(String shopId) {
    return _service.getTodayAttendance(shopId);
  }
}