part of 'upcoming_bookings_bloc.dart';

abstract class UpcomingBookingsEvent extends Equatable {
  const UpcomingBookingsEvent();
}

class GetUpcomingBookings extends UpcomingBookingsEvent {
  final int offset;
  final bool forLoadMore;
  const GetUpcomingBookings({required this.offset, required this.forLoadMore});
  @override
  List<Object?> get props => [offset, forLoadMore];
}
