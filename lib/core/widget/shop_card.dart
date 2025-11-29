import 'package:attendance/core/widget/shopImage.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/presentation/screens/attendance_screen/attendance_screen.dart';

import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  final ShopModel shop;

  const ShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToAttendance(context),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: ShopImage(imageUrl: shop.imageUrl),
          title: Text(
            shop.shopName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Location: ${shop.latitude.toStringAsFixed(4)}, ${shop.longitude.toStringAsFixed(4)}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Radius: ${shop.radius}m',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  void _navigateToAttendance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendanceScreen(shop: shop),
      ),
    );
  }
}
