import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/core/widget/header_widget.dart';
import 'package:attendance/core/widget/location_details_widget.dart';
import 'package:attendance/core/widget/punch_button.dart';
import 'package:attendance/core/widget/status_section.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/data/models/shop_model.dart';

class PunchWidget extends StatefulWidget {
  final ShopModel shop;
  final bool isCameraReady;
  final bool isWithinRadius;
  final bool isCheckingLocation;
  final Position? currentPosition;
  final AttendanceRecord? todayAttendance;
  final CameraController? cameraController;
  final bool isProcessingPunch;
  final VoidCallback onCheckLocation;
  final VoidCallback onTakeSelfieAndPunchIn;
  final VoidCallback onTakeSelfieAndPunchOut;

  const PunchWidget({
    super.key,
    required this.shop,
    required this.isCameraReady,
    required this.isWithinRadius,
    required this.isCheckingLocation,
    required this.currentPosition,
    required this.todayAttendance,
    required this.cameraController,
    required this.isProcessingPunch,
    required this.onCheckLocation,
    required this.onTakeSelfieAndPunchIn,
    required this.onTakeSelfieAndPunchOut,
  });

  @override
  State<PunchWidget> createState() => _PunchWidgetState();
}

class _PunchWidgetState extends State<PunchWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCameraPreview(),
                const SizedBox(width: 16),
                _buildLocationDetails(),
              ],
            ),
            const SizedBox(height: 60),
            if (widget.todayAttendance != null) _buildStatusSection(),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  
  Widget _buildHeader() {
    return HeaderWidget(
      shopName: widget.shop.shopName,
      isWithinRadius: widget.isWithinRadius,
    );
  }

  //  -------  cammera
  Widget _buildCameraPreview() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.zWhite,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (widget.isCameraReady && widget.cameraController != null)
              CameraPreview(widget.cameraController!)
            else
              Container(
                color: AppColors.zGrey,
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: AppColors.zGrey,
                  ),
                ),
              ),
            if (widget.isProcessingPunch)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.zWhite),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // location deatilses
  Widget _buildLocationDetails() {
    return LocationDetailsWidget(
      currentPosition: widget.currentPosition,
      shop: widget.shop,
    );
  }

  // time in and out
  Widget _buildStatusSection() {
    return StatusSection(
      punchInTime: widget.todayAttendance?.punchInTime,
      punchOutTime: widget.todayAttendance?.punchOutTime,
    );
  }

  // action buttion
  Widget _buildActionButton() {
    return PunchButtonWidget(
      isCameraReady: widget.isCameraReady,
      isWithinRadius: widget.isWithinRadius,
      isPunchedIn: widget.todayAttendance != null &&
          widget.todayAttendance!.punchOutTime == null,
      isPunchedOut: widget.todayAttendance != null &&
          widget.todayAttendance!.punchOutTime != null,
      isProcessingPunch: widget.isProcessingPunch,
      onPunchIn: widget.onTakeSelfieAndPunchIn,
      onPunchOut: widget.onTakeSelfieAndPunchOut,
    );
  }
}