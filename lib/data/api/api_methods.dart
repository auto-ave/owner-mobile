import 'package:dio/dio.dart';
import 'package:owner_app/data/models/auth_tokens.dart';
import 'package:owner_app/data/models/booking_list.dart';

abstract class ApiMethods {
  Future<AuthTokensEntity> login(
      {required String email,
      required String password,
      required String fcmToken});
  Future<List<BookingListEntity>> getUpcomingBookings({required int offset});
  Future<dynamic> startService(
      {required String bookingId, required String otp});
  Future<dynamic> completeService({required String bookingId});
  Future<List<BookingListEntity>> getPastBookings({required int offset});

  Future<List<BookingListEntity>> getBookingsByDate({required String date});
  Future<void> sendFeedback(
      {required String email,
      required String phoneNumber,
      required String message});
}
