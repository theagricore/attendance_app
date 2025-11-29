import 'dart:io';
import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:attendance/presentation/screens/attendance_screen/widget/history_widget.dart';
import 'package:attendance/presentation/screens/attendance_screen/widget/punch_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceScreen extends StatefulWidget {
  final ShopModel shop;

  const AttendanceScreen({super.key, required this.shop});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  bool _isWithinRadius = false;
  Position? _currentPosition;
  bool _isCheckingLocation = false;
  AttendanceRecord? _todayAttendance;
  List<AttendanceRecord> _attendanceHistory = [];
  bool _isProcessingPunch = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _checkLocation();
    _loadTodayAttendance();
    _loadAttendanceHistory();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is SelfieImageUploaded) {
          if (_todayAttendance == null) {
            _punchIn(state.imageUrl);
          } else {
            _punchOut(state.imageUrl);
          }
        } else if (state is AttendanceRecordAdded) {
          setState(() {
            _isProcessingPunch = false;
          });
          _showSuccessSnackBar(state.message);
          _loadTodayAttendance();
          _loadAttendanceHistory();
        } else if (state is AttendanceRecordUpdated) {
          setState(() {
            _isProcessingPunch = false;
          });
          _showSuccessSnackBar(state.message);
          _loadTodayAttendance();
          _loadAttendanceHistory();
        } else if (state is TodayAttendanceLoaded) {
          setState(() {
            _todayAttendance = state.attendance;
          });
        } else if (state is AttendanceRecordsLoaded) {
          setState(() {
            _attendanceHistory = state.records;
          });
        } else if (state is AttendanceError) {
          setState(() {
            _isProcessingPunch = false;
          });
          _showErrorSnackBar(state.message);
        } else if (state is SelfieUploading) {
          setState(() {
            _isProcessingPunch = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Attendance Screen"),
          backgroundColor: AppColors.zPrimaryColor,
          foregroundColor: AppColors.zWhite,
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalHeight = constraints.maxHeight;
              final topHeight = totalHeight * 0.46;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: topHeight,
                      child: PunchWidget(
                        shop: widget.shop,
                        isCameraReady: _isCameraReady,
                        isWithinRadius: _isWithinRadius,
                        isCheckingLocation: _isCheckingLocation,
                        currentPosition: _currentPosition,
                        todayAttendance: _todayAttendance,
                        cameraController: _cameraController,
                        isProcessingPunch: _isProcessingPunch,
                        onCheckLocation: _checkLocation,
                        onTakeSelfieAndPunchIn: _takeSelfieAndPunchIn,
                        onTakeSelfieAndPunchOut: _takeSelfieAndPunchOut,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: HistoryWidget(
                        attendanceHistory: _attendanceHistory,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraReady = true;
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
      if (mounted) {
        setState(() {
          _isCameraReady = false;
        });
      }
    }
  }

  Future<void> _checkLocation() async {
    setState(() {
      _isCheckingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar(
          'Location permissions are permanently denied. Please enable them in app settings.',
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double distance = Geolocator.distanceBetween(
        widget.shop.latitude,
        widget.shop.longitude,
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _isWithinRadius = distance <= widget.shop.radius;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to get location: $e');
    } finally {
      setState(() {
        _isCheckingLocation = false;
      });
    }
  }

  void _loadTodayAttendance() {
    context.read<AttendanceBloc>().add(
      GetTodayAttendanceEvent(widget.shop.shopId),
    );
  }

  void _loadAttendanceHistory() {
    context.read<AttendanceBloc>().add(
      GetAttendanceRecordsEvent(widget.shop.shopId),
    );
  }

  Future<void> _takeSelfieAndPunchIn() async {
    if (!_isCameraReady || !_isWithinRadius || _cameraController == null) {
      _showErrorSnackBar('Camera not ready or not within location radius');
      return;
    }

    if (_isProcessingPunch) return;

    setState(() {
      _isProcessingPunch = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);

      context.read<AttendanceBloc>().add(UploadSelfieImageEvent(imageFile));
    } catch (e) {
      setState(() {
        _isProcessingPunch = false;
      });
      _showErrorSnackBar('Failed to take selfie: $e');
    }
  }

  Future<void> _takeSelfieAndPunchOut() async {
    if (!_isCameraReady ||
        _todayAttendance == null ||
        _cameraController == null) {
      _showErrorSnackBar('Camera not ready or no active punch in');
      return;
    }

    if (_isProcessingPunch) return;

    setState(() {
      _isProcessingPunch = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);

      context.read<AttendanceBloc>().add(UploadSelfieImageEvent(imageFile));
    } catch (e) {
      setState(() {
        _isProcessingPunch = false;
      });
      _showErrorSnackBar('Failed to take selfie: $e');
    }
  }

  void _punchIn(String selfieUrl) {
    final record = AttendanceRecord(
      recordId: DateTime.now().millisecondsSinceEpoch.toString(),
      shopId: widget.shop.shopId,
      shopName: widget.shop.shopName,
      punchInTime: DateTime.now(),
      punchInSelfieUrl: selfieUrl,
      punchInLatitude: _currentPosition!.latitude,
      punchInLongitude: _currentPosition!.longitude,
    );

    context.read<AttendanceBloc>().add(AddAttendanceRecordEvent(record));
  }

  void _punchOut(String selfieUrl) {
    if (_todayAttendance == null) return;

    final updatedRecord = AttendanceRecord(
      recordId: _todayAttendance!.recordId,
      shopId: _todayAttendance!.shopId,
      shopName: _todayAttendance!.shopName,
      punchInTime: _todayAttendance!.punchInTime,
      punchOutTime: DateTime.now(),
      punchInSelfieUrl: _todayAttendance!.punchInSelfieUrl,
      punchOutSelfieUrl: selfieUrl,
      punchInLatitude: _todayAttendance!.punchInLatitude,
      punchInLongitude: _todayAttendance!.punchInLongitude,
      punchOutLatitude: _currentPosition!.latitude,
      punchOutLongitude: _currentPosition!.longitude,
    );

    context.read<AttendanceBloc>().add(
      UpdateAttendanceRecordEvent(updatedRecord),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.zRed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.zGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
