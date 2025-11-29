part of 'shop_bloc.dart';

@immutable
abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopError extends ShopState {
  final String message;

  ShopError(this.message);
}

class ShopAdded extends ShopState {
  final String message;

  ShopAdded(this.message);
}

class ShopsLoaded extends ShopState {
  final List<ShopModel> shops;

  ShopsLoaded(this.shops);
}
class ShopImageUploaded extends ShopState {
  final String imageUrl;

  ShopImageUploaded(this.imageUrl);
}