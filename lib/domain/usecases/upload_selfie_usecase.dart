import 'dart:io';
import 'package:attendance/data/datasources/cloudinary_service.dart';
import 'package:dartz/dartz.dart';

class UploadSelfieUsecase {
  final CloudinaryService cloudinaryService;

  UploadSelfieUsecase(this.cloudinaryService);

  Future<Either<String, String>> call(File imageFile) {
    return cloudinaryService.uploadSelfieImage(imageFile);
  }
}