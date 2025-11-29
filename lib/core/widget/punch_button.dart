import 'package:attendance/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class PunchButtonWidget extends StatelessWidget {
  final bool isCameraReady;
  final bool isWithinRadius;
  final bool isPunchedIn;
  final bool isPunchedOut;
  final bool isProcessingPunch;
  final VoidCallback onPunchIn;
  final VoidCallback onPunchOut;

  const PunchButtonWidget({
    super.key,
    required this.isCameraReady,
    required this.isWithinRadius,
    required this.isPunchedIn,
    required this.isPunchedOut,
    required this.isProcessingPunch,
    required this.onPunchIn,
    required this.onPunchOut,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonText;
    final Color buttonColor;
    final bool isEnabled;

    if (isProcessingPunch) {
      buttonText = 'Processing...';
      buttonColor = AppColors.zOrande;
      isEnabled = false;
    } else if (isPunchedIn == false && isPunchedOut == false) {
      buttonText = 'Punch In';
      buttonColor = AppColors.zGreen;
      isEnabled = isCameraReady && isWithinRadius;
    } else if (isPunchedIn == true && isPunchedOut == false) {
      buttonText = 'Punch Out';
      buttonColor = AppColors.zRed;
      isEnabled = isCameraReady && isWithinRadius;
    } else {
      buttonText = 'Completed';
      buttonColor = AppColors.zGrey;
      isEnabled = false;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isEnabled && !isProcessingPunch
            ? (isPunchedIn ? onPunchOut : onPunchIn)
            : null,
        style: ElevatedButton.styleFrom(
          elevation: 6,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: buttonColor,
          foregroundColor: AppColors.zWhite,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
        ),
       
        label: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}