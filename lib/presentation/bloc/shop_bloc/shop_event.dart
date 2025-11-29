part of 'shop_bloc.dart';

@immutable
abstract class ShopEvent {}

class AddShopEvent extends ShopEvent {
  final ShopModel shop;

  AddShopEvent(this.shop);
}

class GetShopsEvent extends ShopEvent {}
class UploadShopImageEvent extends ShopEvent {
  final File imageFile;

  UploadShopImageEvent(this.imageFile);
}