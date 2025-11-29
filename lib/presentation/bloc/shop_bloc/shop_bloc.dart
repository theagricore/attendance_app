import 'dart:io';

import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/domain/usecases/add_shop_usecase.dart';
import 'package:attendance/domain/usecases/get_shops_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final AddShopUsecase _addShopUsecase;
  final GetShopsUsecase _getShopsUsecase;

  ShopBloc({
    required AddShopUsecase addShopUsecase,
    required GetShopsUsecase getShopsUsecase,
  }) : _addShopUsecase = addShopUsecase,
       _getShopsUsecase = getShopsUsecase,
       super(ShopInitial()) {
    on<AddShopEvent>(_onAddShop);
    on<GetShopsEvent>(_onGetShops);
  }

  Future<void> _onAddShop(AddShopEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoading());
    final result = await _addShopUsecase(event.shop);
    result.fold(
      (failure) => emit(ShopError(failure)),
      (success) {
        emit(ShopAdded(success));
        add(GetShopsEvent());
      },
    );
  }

  Future<void> _onGetShops(GetShopsEvent event, Emitter<ShopState> emit) async {
    emit(ShopLoading());
    final result = await _getShopsUsecase();
    result.fold(
      (failure) => emit(ShopError(failure)),
      (shops) => emit(ShopsLoaded(shops)),
    );
  }
}