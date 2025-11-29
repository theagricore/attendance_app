import 'dart:io';
import 'package:attendance/core/cloudinary/cloudinary_config.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';

abstract class CloudinaryService {
  Future<Either<String, String>> uploadShopImage(File imageFile);
  Future<Either<String, String>> uploadSelfieImage(File imageFile);
}

class CloudinaryServiceImpl implements CloudinaryService {
  final cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
  );

  @override
  Future<Either<String, String>> uploadShopImage(File imageFile) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'shop_images',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return Right(response.secureUrl);
    } catch (e) {
      return Left('Failed to upload image: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> uploadSelfieImage(File imageFile) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'selfies',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return Right(response.secureUrl);
    } catch (e) {
      return Left('Failed to upload selfie: ${e.toString()}');
    }
  }
}