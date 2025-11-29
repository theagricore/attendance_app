import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceRepository {
  Future<Either<String, String>> addShop(ShopModel shop);
  Future<Either<String, List<ShopModel>>> getShops();
  Future<Either<String, String>> addAttendanceRecord(AttendanceRecord record);
  Future<Either<String, List<AttendanceRecord>>> getAttendanceRecords(String shopId);
  Future<Either<String, String>> updateAttendanceRecord(AttendanceRecord record);
  Future<Either<String, AttendanceRecord?>> getTodayAttendance(String shopId);
}