import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/core/widget/shop_list.dart';
import 'package:attendance/presentation/bloc/shop_bloc/shop_bloc.dart';
import 'package:attendance/presentation/screens/add_shop_screen/add_shop_screen.dart';
import 'package:attendance/service_locator/service_locater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ShopBloc>()..add(GetShopsEvent()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.zPrimaryColor,
          title: const Text(
            "Shop List",
            style: TextStyle(color: AppColors.zWhite),
          ),
        ),
        body: const ShopList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.zPrimaryColor,
          onPressed: () => _navigateToAddShop(context),
          child: const Icon(Icons.add,color: AppColors.zWhite,),
        ),
      ),
    );
  }

  void _navigateToAddShop(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<ShopBloc>(),
          child: const AddShopScreen(),
        ),
      ),
    ).then((_) {
      context.read<ShopBloc>().add(GetShopsEvent());
    });
  }
}