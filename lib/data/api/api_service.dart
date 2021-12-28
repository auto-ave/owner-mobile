import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:owner_app/data/api/api_endpoints.dart';
import 'package:owner_app/data/api/api_methods.dart';
import 'package:owner_app/data/models/auth_tokens.dart';
import 'package:owner_app/data/models/booking_list.dart';

class ApiService implements ApiMethods {
  static const getItInstanceName = 'ApiService';
  CancelToken createSlotsCancelToken = CancelToken();
  final ApiConstants _apiConstants;
  ApiService({required ApiConstants apiConstants})
      : _apiConstants = apiConstants;

  @override
  Future<AuthTokensEntity> login(
      {required String email,
      required String password,
      required String fcmToken}) async {
    Dio client = _apiConstants.dioClient();
    String url = _apiConstants.postStoreOwnerLoginEndPoint();

    Response res = await client.post(
      url,
      data: {'email': email, 'password': password, 'token': fcmToken},
    );

    // print("CHECK OTP " + token);

    if (res.statusCode == 200) {
      dynamic data = jsonDecode(res.data);
      return AuthTokensEntity.fromJson(data);
    } else {
      return AuthTokensEntity(refreshToken: '', accessToken: '');
    }
  }

  @override
  Future<List<BookingListEntity>> getUpcomingBookings(
      {required int offset}) async {
    Dio client = _apiConstants.dioClient();
    String url =
        _apiConstants.getStoreOwnerUpcomingBookingsEndPoint(offset: offset);
    Response res = await client.get(url);
    dynamic data = jsonDecode(res.data);

    print(data['results'].toString() + "hello");
    List<BookingListEntity> bookings = data['results']
        .map<BookingListEntity>((e) => BookingListEntity.fromJson(e))
        .toList();

    return bookings;
  }

  @override
  Future startService({required String bookingId, required String otp}) async {
    Dio client = _apiConstants.dioClient();
    String url = _apiConstants.postStoreOwnerServiceStartEndPoint();
    Response res =
        await client.post(url, data: {'booking_id': bookingId, 'otp': otp});
    dynamic data = jsonDecode(res.data);
    return data;
  }

  @override
  Future completeService({required String bookingId}) async {
    Dio client = _apiConstants.dioClient();
    String url = _apiConstants.postStoreOwnerServiceCompleteEndPoint();
    Response res = await client.post(url, data: {'booking_id': bookingId});
    dynamic data = jsonDecode(res.data);
    return data;
  }

  @override
  Future<List<BookingListEntity>> getBookingsByDate(
      {required String date}) async {
    Dio client = _apiConstants.dioClient();
    String url = _apiConstants.getStoreOwnerBookingsByDateEndPoint(date: date);
    Response res = await client.get(url);
    dynamic data = jsonDecode(res.data);

    print(data['results'].toString() + "hello");
    List<BookingListEntity> bookings = data['results']
        .map<BookingListEntity>((e) => BookingListEntity.fromJson(e))
        .toList();

    return bookings;
  }

  @override
  Future<List<BookingListEntity>> getPastBookings({required int offset}) async {
    Dio client = _apiConstants.dioClient();
    String url = _apiConstants.getStoreOwnerPastBookingsEndPoint();
    Response res = await client.get(url);
    dynamic data = jsonDecode(res.data);

    print(data['results'].toString() + "hello");
    List<BookingListEntity> bookings = data['results']
        .map<BookingListEntity>((e) => BookingListEntity.fromJson(e))
        .toList();

    return bookings;
  }

  @override
  Future<void> sendFeedback(
      {required String email,
      required String phoneNumber,
      required String message}) async {
    Dio client = _apiConstants.dioClient();
    String url = _apiConstants.getFeedbackEndpoint();
    Response res = await client.post(url,
        data: {'phone': phoneNumber, 'email': email, 'message': message});
  }
}
