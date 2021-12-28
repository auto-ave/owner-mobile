part of 'upcoming_bookings_bloc.dart';

abstract class UpcomingBookingsState extends Equatable {
  const UpcomingBookingsState();
}

class UpcomingBookingsInitial extends UpcomingBookingsState {
  @override
  List<Object?> get props => [];
}

class UpcomingBookingsLoaded extends UpcomingBookingsState {
  final List<BookingListModel> bookings;
  final bool hasReachedMax;
  UpcomingBookingsLoaded({required this.bookings, required this.hasReachedMax});

  @override
  List<Object?> get props => [bookings];
}

class UpcomingBookingsLoading extends UpcomingBookingsState {
  @override
  List<Object?> get props => [];
}

class MoreUpcomingBookingsLoading extends UpcomingBookingsState {
  @override
  List<Object?> get props => [];
}

class UpcomingBookingsError extends UpcomingBookingsState {
  final String message;
  UpcomingBookingsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
