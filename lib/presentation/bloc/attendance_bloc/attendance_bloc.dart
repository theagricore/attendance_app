import 'dart:io';
import 'package:attendance/data/models/attendance_model.dart';
import 'package:attendance/domain/usecases/add_attendance_record_usecase.dart';
import 'package:attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:attendance/domain/usecases/update_attendance_record_usecase.dart';
import 'package:attendance/domain/usecases/get_attendance_records_usecase.dart';
import 'package:attendance/domain/usecases/upload_selfie_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AddAttendanceRecordUsecase _addAttendanceRecordUsecase;
  final GetTodayAttendanceUsecase _getTodayAttendanceUsecase;
  final UpdateAttendanceRecordUsecase _updateAttendanceRecordUsecase;
  final GetAttendanceRecordsUsecase _getAttendanceRecordsUsecase;
  final UploadSelfieUsecase _uploadSelfieUsecase;

  AttendanceBloc({
    required AddAttendanceRecordUsecase addAttendanceRecordUsecase,
    required GetTodayAttendanceUsecase getTodayAttendanceUsecase,
    required UpdateAttendanceRecordUsecase updateAttendanceRecordUsecase,
    required GetAttendanceRecordsUsecase getAttendanceRecordsUsecase,
    required UploadSelfieUsecase uploadSelfieUsecase,
  })  : _addAttendanceRecordUsecase = addAttendanceRecordUsecase,
        _getTodayAttendanceUsecase = getTodayAttendanceUsecase,
        _updateAttendanceRecordUsecase = updateAttendanceRecordUsecase,
        _getAttendanceRecordsUsecase = getAttendanceRecordsUsecase,
        _uploadSelfieUsecase = uploadSelfieUsecase,
        super(AttendanceInitial()) {
    on<AddAttendanceRecordEvent>(_onAddAttendanceRecord);
    on<GetTodayAttendanceEvent>(_onGetTodayAttendance);
    on<UpdateAttendanceRecordEvent>(_onUpdateAttendanceRecord);
    on<GetAttendanceRecordsEvent>(_onGetAttendanceRecords);
    on<UploadSelfieImageEvent>(_onUploadSelfieImage);
  }

  Future<void> _onAddAttendanceRecord(
    AddAttendanceRecordEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final result = await _addAttendanceRecordUsecase(event.record);
      result.fold(
        (failure) => emit(AttendanceError(failure)),
        (success) => emit(AttendanceRecordAdded(success)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to add attendance record: $e'));
    }
  }

  Future<void> _onGetTodayAttendance(
    GetTodayAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final result = await _getTodayAttendanceUsecase(event.shopId);
      result.fold(
        (failure) => emit(AttendanceError(failure)),
        (attendance) => emit(TodayAttendanceLoaded(attendance)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to get today\'s attendance: $e'));
    }
  }

  Future<void> _onUpdateAttendanceRecord(
    UpdateAttendanceRecordEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final result = await _updateAttendanceRecordUsecase(event.record);
      result.fold(
        (failure) => emit(AttendanceError(failure)),
        (success) => emit(AttendanceRecordUpdated(success)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to update attendance record: $e'));
    }
  }

  Future<void> _onGetAttendanceRecords(
    GetAttendanceRecordsEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final result = await _getAttendanceRecordsUsecase(event.shopId);
      result.fold(
        (failure) => emit(AttendanceError(failure)),
        (records) => emit(AttendanceRecordsLoaded(records)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to get attendance records: $e'));
    }
  }

  Future<void> _onUploadSelfieImage(
    UploadSelfieImageEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(SelfieUploading());
    try {
      final result = await _uploadSelfieUsecase(event.imageFile);
      result.fold(
        (failure) => emit(AttendanceError(failure)),
        (imageUrl) => emit(SelfieImageUploaded(imageUrl)),
      );
    } catch (e) {
      emit(AttendanceError('Failed to upload selfie: $e'));
    }
  }
}