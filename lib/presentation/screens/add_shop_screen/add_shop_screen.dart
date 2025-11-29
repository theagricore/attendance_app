import 'dart:io';
import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/core/widget/custom_text_form_field.dart';
import 'package:attendance/data/datasources/cloudinary_service.dart';
import 'package:attendance/data/models/shop_model.dart';
import 'package:attendance/presentation/bloc/shop_bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _radiusController = TextEditingController(text: '100');

  File? _pickedImage;
  String? _uploadedImageUrl;
  bool _loadingLocation = false;
  bool _uploadingImage = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Shop"),
        backgroundColor: AppColors.zPrimaryColor,
        foregroundColor: AppColors.zWhite,
      ),
      body: BlocListener<ShopBloc, ShopState>(
        listener: (context, state) {
          if (state is ShopAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          }
          if (state is ShopError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: _buildFormContent(),
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 20),
            _buildShopNameField(),
            const SizedBox(height: 16),
            _buildLocationFields(),
            const SizedBox(height: 16),
            _buildLocationButton(),
            const SizedBox(height: 16),
            _buildRadiusField(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _uploadingImage ? null : _pickImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.zGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildImageContent(),
          ),
        ),
        if (_uploadedImageUrl != null) _buildUploadSuccess(),
      ],
    );
  }

  Widget _buildImageContent() {
    if (_uploadingImage) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    } else if (_pickedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_pickedImage!, fit: BoxFit.cover),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, size: 40, color: AppColors.zGrey),
          const SizedBox(height: 8),
          Text("Tap to add image", style: TextStyle(color: AppColors.zGrey)),
        ],
      );
    }
  }

  Widget _buildUploadSuccess() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        "✓ Image uploaded",
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.zGreen, fontSize: 12),
      ),
    );
  }

  Widget _buildShopNameField() {
    return CustomTextFormField(
      controller: _shopNameController,
      label: "Shop Name",
    );
  }

  Widget _buildLocationFields() {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: _latitudeController,
            label: "Latitude",
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextFormField(
            controller: _longitudeController,
            label: "Longitude",
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationButton() {
    return ElevatedButton.icon(
      onPressed: _loadingLocation ? null : _getLocation,
      icon: _loadingLocation
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.location_on),
      label: Text(_loadingLocation ? "Getting Location..." : "Get Current Location"),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.zPrimaryColor,
        foregroundColor: AppColors.zWhite,
      ),
    );
  }

  Widget _buildRadiusField() {
    return CustomTextFormField(
      controller: _radiusController,
      label: "Radius",
      keyboardType: TextInputType.number,
      suffixText: "m",
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final isLoading = state is ShopLoading || _uploadingImage;
        return ElevatedButton(
          onPressed: isLoading ? null : _addShop,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.zPrimaryColor,
            foregroundColor: AppColors.zWhite,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.zWhite),
                  ),
                )
              : const Text("Add Shop", style: TextStyle(fontSize: 16)),
        );
      },
    );
  }

  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latitudeController.text = pos.latitude.toStringAsFixed(6);
      _longitudeController.text = pos.longitude.toStringAsFixed(6);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get location: $e")),
      );
    } finally {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (img == null) return;

    setState(() {
      _pickedImage = File(img.path);
      _uploadingImage = true;
    });

    final service = CloudinaryServiceImpl();
    final result = await service.uploadShopImage(_pickedImage!);

    result.fold(
      (failure) {
        setState(() => _uploadingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image upload failed: $failure")),
        );
      },
      (url) {
        setState(() {
          _uploadedImageUrl = url;
          _uploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      },
    );
  }

  void _addShop() {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImage != null && _uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploading image...")),
      );
      return;
    }

    final shop = ShopModel(
      shopId: DateTime.now().millisecondsSinceEpoch.toString(),
      shopName: _shopNameController.text.trim(),
      latitude: double.parse(_latitudeController.text),
      longitude: double.parse(_longitudeController.text),
      radius: double.parse(_radiusController.text),
      createdAt: DateTime.now(),
      imageUrl: _uploadedImageUrl,
    );

    context.read<ShopBloc>().add(AddShopEvent(shop));
  }
}