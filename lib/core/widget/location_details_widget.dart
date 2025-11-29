import 'package:attendance/core/widget/detail_row_widget.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetailsWidget extends StatelessWidget {
  final Position? currentPosition;
  final ShopModel shop;

  const LocationDetailsWidget({
    super.key,
    required this.currentPosition,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (currentPosition != null)
            DetailRowWidget(
              label: 'Your Location',
              value:
                  '${currentPosition!.latitude.toStringAsFixed(5)}, ${currentPosition!.longitude.toStringAsFixed(5)}',
              icon: Icons.person_pin_circle_outlined,
            ),
          DetailRowWidget(
            label: 'Shop Location',
            value:
                '${shop.latitude.toStringAsFixed(5)}, ${shop.longitude.toStringAsFixed(5)}',
            icon: Icons.store_outlined,
          ),
        ],
      ),
    );
  }
}
