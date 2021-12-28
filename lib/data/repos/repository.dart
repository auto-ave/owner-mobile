import 'package:owner_app/data/models/booking_list.dart';

abstract class Repository {
  Future<List<BookingListModel>> getUpcomingBookings({required int offset});
  Future<dynamic> startService(
      {required String bookingId, required String otp});
  Future<dynamic> completeService({required String bookingId});
  Future<List<BookingListModel>> getPastBookings({required int offset});

  Future<List<BookingListModel>> getBookingsByDate({required DateTime date});
  Future<void> sendFeedback(
      {required String email,
      required String phoneNumber,
      required String message});
}
