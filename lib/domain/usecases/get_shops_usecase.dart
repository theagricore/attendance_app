import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:dartz/dartz.dart';

class GetShopsUsecase {
  final AttendanceRepository repository;

  GetShopsUsecase(this.repository);

  Future<Either<String, List<ShopModel>>> call() {
    return repository.getShops();
  }
}