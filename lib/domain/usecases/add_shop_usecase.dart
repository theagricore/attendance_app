import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:dartz/dartz.dart';

class AddShopUsecase {
  final AttendanceRepository repository;

  AddShopUsecase(this.repository);

  Future<Either<String, String>> call(ShopModel shop) {
    return repository.addShop(shop);
  }
}