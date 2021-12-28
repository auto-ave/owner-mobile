import 'package:intl/intl.dart';
import 'package:owner_app/data/api/api_methods.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/data/repos/repository.dart';

class RestRepository extends Repository {
  final ApiMethods _apiMethodsImp;
  RestRepository({required ApiMethods apiMethodsImp})
      : _apiMethodsImp = apiMethodsImp;
  @override
  Future<List<BookingListModel>> getUpcomingBookings(
      {required int offset}) async {
    List<BookingListEntity> entity =
        await _apiMethodsImp.getUpcomingBookings(offset: offset);
    print(entity.toString() + "entity");
    List<BookingListModel> bookings =
        entity.map((e) => BookingListModel.fromEntity(e)).toList();
    return bookings;
  }

  @override
  Future startService({required String bookingId, required String otp}) async {
    var data =
        await _apiMethodsImp.startService(bookingId: bookingId, otp: otp);
  }

  @override
  Future completeService({required String bookingId}) async {
    var data = await _apiMethodsImp.completeService(bookingId: bookingId);
  }

  @override
  Future<List<BookingListModel>> getBookingsByDate(
      {required DateTime date}) async {
    List<BookingListEntity> entity = await _apiMethodsImp.getBookingsByDate(
        date: DateFormat('y-M-d').format(date));
    print(entity.toString() + "entity");
    List<BookingListModel> bookings =
        entity.map((e) => BookingListModel.fromEntity(e)).toList();
    return bookings;
  }

  @override
  Future<List<BookingListModel>> getPastBookings({required int offset}) async {
    List<BookingListEntity> entity =
        await _apiMethodsImp.getPastBookings(offset: offset);
    print(entity.toString() + "entity");
    List<BookingListModel> bookings =
        entity.map((e) => BookingListModel.fromEntity(e)).toList();
    return bookings;
  }

  @override
  Future<void> sendFeedback(
      {required String email,
      required String phoneNumber,
      required String message}) async {
    await _apiMethodsImp.sendFeedback(
        email: email, phoneNumber: phoneNumber, message: message);
  }
}
