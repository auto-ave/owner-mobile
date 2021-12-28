part of 'past_bookings_bloc.dart';

abstract class PastBookingsEvent extends Equatable {
  const PastBookingsEvent();
}

class GetPastBookings extends PastBookingsEvent {
  final int offset;
  final bool forLoadMore;
  const GetPastBookings({required this.offset, required this.forLoadMore});
  @override
  List<Object?> get props => [offset, forLoadMore];
}
