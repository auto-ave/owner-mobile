part of 'all_bookings_bloc.dart';

abstract class AllBookingsState extends Equatable {
  const AllBookingsState();
}

class AllBookingsInitial extends AllBookingsState {
  @override
  List<Object> get props => [];
}

class AllBookingsLoading extends AllBookingsState {
  @override
  List<Object> get props => [];
}

class AllBookingsLoaded extends AllBookingsState {
  final List<BookingListModel> bookings;
  const AllBookingsLoaded({
    required this.bookings,
  });
  @override
  List<Object> get props => [bookings];
}

class AllBookingsError extends AllBookingsState {
  final String message;
  const AllBookingsError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
