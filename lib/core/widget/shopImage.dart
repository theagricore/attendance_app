import 'package:attendance/core/theme/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShopImage extends StatelessWidget {
  final String? imageUrl;

  const ShopImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              color: AppColors.zPrimaryColor.withOpacity(0.1),
              child: Icon(Icons.store, color: AppColors.zPrimaryColor, size: 20),
            ),
            errorWidget: (_, _, _) => Container(
              color: AppColors.zPrimaryColor.withOpacity(0.1),
              child: Icon(Icons.store, color: AppColors.zPrimaryColor),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.zPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.store, color: AppColors.zPrimaryColor),
      );
    }
  }
}
