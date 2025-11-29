import 'dart:developer';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class FirebaseAttendanceService {
  Future<Either<String, String>> addShop(ShopModel shop);
  Future<Either<String, List<ShopModel>>> getShops();
  Future<Either<String, String>> addAttendanceRecord(AttendanceRecord record);
  Future<Either<String, List<AttendanceRecord>>> getAttendanceRecords(
    String shopId,
  );
  Future<Either<String, String>> updateAttendanceRecord(
    AttendanceRecord record,
  );
  Future<Either<String, AttendanceRecord?>> getTodayAttendance(String shopId);
}

class FirebaseAttendanceServiceImpl extends FirebaseAttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, String>> addShop(ShopModel shop) async {
    try {
      await _firestore.collection('Shops').doc(shop.shopId).set(shop.toMap());
      return const Right("Shop added successfully");
    } catch (e) {
      log("Add Shop Error: $e");
      return Left("Failed to add shop: $e");
    }
  }

  @override
  Future<Either<String, List<ShopModel>>> getShops() async {
    try {
      final querySnapshot = await _firestore
          .collection('Shops')
          .orderBy('createdAt', descending: true)
          .get();

      final shops = querySnapshot.docs
          .map((doc) => ShopModel.fromMap(doc.data()))
          .toList();

      return Right(shops);
    } catch (e) {
      log("Get Shops Error: $e");
      return Left("Failed to get shops: $e");
    }
  }

  @override
  Future<Either<String, String>> addAttendanceRecord(
    AttendanceRecord record,
  ) async {
    try {
      await _firestore
          .collection('Attendance')
          .doc(record.recordId)
          .set(record.toMap());
      return const Right("Attendance recorded successfully");
    } catch (e) {
      log("Add Attendance Error: $e");
      return Left("Failed to record attendance: $e");
    }
  }

  @override
  Future<Either<String, List<AttendanceRecord>>> getAttendanceRecords(
    String shopId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('Attendance')
          .where('shopId', isEqualTo: shopId)
          .orderBy('punchInTime', descending: true)
          .get();
      final record = querySnapshot.docs
          .map((doc) => AttendanceRecord.fromMap(doc.data()))
          .toList();
      return Right(record);
    } catch (e) {
      log("Get Attendance Error: $e");
      return Left("Failed to get attendance records: $e");
    }
  }

  @override
  Future<Either<String, String>> updateAttendanceRecord(
    AttendanceRecord record,
  ) async {
    try {
      await _firestore
          .collection('Attendance')
          .doc(record.recordId)
          .update(record.toMap());
      return const Right("Attendance updated successfully");
    } catch (e) {
      log("Update Attendance Error: $e");
      return Left("Failed to update attendance: $e");
    }
  }

  @override
  Future<Either<String, AttendanceRecord?>> getTodayAttendance(
    String shopId,
  ) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('Attendance')
          .where('shopId', isEqualTo: shopId)
          .where(
            'punchInTime',
            isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch,
          )
          .where(
            'punchInTime',
            isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch,
          )
          .orderBy('punchInTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return Right(null);
      }

      final record = AttendanceRecord.fromMap(querySnapshot.docs.first.data());
      return Right(record);
    } catch (e) {
      log("Get Today Attendance Error: $e");
      return Left("Failed to get today's attendance: $e");
    }
  }
}
