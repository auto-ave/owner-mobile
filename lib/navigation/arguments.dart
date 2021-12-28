import 'package:owner_app/data/models/booking_list.dart';

class BookingDetailScreenArguments {
  final BookingListModel booking;
  BookingDetailScreenArguments({
    required this.booking,
  });
}

class FeedbackScreenArguments {
  final bool isFeedback;
  final String? orderNumber;
  FeedbackScreenArguments({
    required this.isFeedback,
    this.orderNumber,
  });
}
