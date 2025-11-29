import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/presentation/bloc/shop_bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shop_card.dart';

class ShopList extends StatelessWidget {
  const ShopList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        if (state is ShopLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ShopError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ShopsLoaded) {
          final shops = state.shops;
          if (shops.isEmpty) return const _EmptyShopMessage();

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ShopBloc>().add(GetShopsEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return ShopCard(shop: shop);
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _EmptyShopMessage extends StatelessWidget {
  const _EmptyShopMessage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No shops added yet\nTap + to add a new shop',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: AppColors.zGrey),
      ),
    );
  }
}