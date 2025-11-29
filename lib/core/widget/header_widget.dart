import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String shopName;
  final bool isWithinRadius;

  const HeaderWidget({
    super.key,
    required this.shopName,
    required this.isWithinRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            shopName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _StatusBadge(inRange: isWithinRadius),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool inRange;

  const _StatusBadge({required this.inRange});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        inRange ? Colors.green.shade700 : Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: inRange ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 0.5),
      ),
      child: Text(
        inRange ? 'Inside Radius' : 'Outside Radius',
        style: TextStyle(
          fontSize: 12,
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
