import 'package:attendance/data/datasources/cloudinary_service.dart';
import 'package:attendance/data/datasources/firebase_attendance_service.dart';
import 'package:attendance/data/repositories/attendance_repository_impl.dart';
import 'package:attendance/domain/repositories/attendance_repository.dart';
import 'package:attendance/domain/usecases/add_shop_usecase.dart';
import 'package:attendance/domain/usecases/get_shops_usecase.dart';
import 'package:attendance/domain/usecases/add_attendance_record_usecase.dart';
import 'package:attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:attendance/domain/usecases/update_attendance_record_usecase.dart';
import 'package:attendance/domain/usecases/get_attendance_records_usecase.dart';
import 'package:attendance/domain/usecases/upload_selfie_usecase.dart';
import 'package:attendance/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:attendance/presentation/bloc/shop_bloc/shop_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  sl.registerLazySingleton<FirebaseAttendanceService>(
    () => FirebaseAttendanceServiceImpl(),
  );
  sl.registerLazySingleton<CloudinaryService>(
    () => CloudinaryServiceImpl(),
  );
  
  // Repositories
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(),
  );
  
  // UseCases - Shop Related
  sl.registerLazySingleton<AddShopUsecase>(
    () => AddShopUsecase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetShopsUsecase>(
    () => GetShopsUsecase(sl<AttendanceRepository>()),
  );
  
  // UseCases - Attendance Related
  sl.registerLazySingleton<AddAttendanceRecordUsecase>(
    () => AddAttendanceRecordUsecase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetTodayAttendanceUsecase>(
    () => GetTodayAttendanceUsecase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<UpdateAttendanceRecordUsecase>(
    () => UpdateAttendanceRecordUsecase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<GetAttendanceRecordsUsecase>(
    () => GetAttendanceRecordsUsecase(sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton<UploadSelfieUsecase>(
    () => UploadSelfieUsecase(sl<CloudinaryService>()),
  );
  
  // Blocs
  sl.registerFactory<ShopBloc>(
    () => ShopBloc(
      addShopUsecase: sl<AddShopUsecase>(),
      getShopsUsecase: sl<GetShopsUsecase>(),
    ),
  );
  
  sl.registerFactory<AttendanceBloc>(
    () => AttendanceBloc(
      addAttendanceRecordUsecase: sl<AddAttendanceRecordUsecase>(),
      getTodayAttendanceUsecase: sl<GetTodayAttendanceUsecase>(),
      updateAttendanceRecordUsecase: sl<UpdateAttendanceRecordUsecase>(),
      getAttendanceRecordsUsecase: sl<GetAttendanceRecordsUsecase>(),
       uploadSelfieUsecase: sl<UploadSelfieUsecase>(),
    ),
  );
}