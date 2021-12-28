part of 'all_bookings_bloc.dart';

abstract class AllBookingsEvent extends Equatable {
  const AllBookingsEvent();
}

class GetAllBookingsByDate extends AllBookingsEvent {
  final DateTime date;
  const GetAllBookingsByDate({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}
