part of 'past_bookings_bloc.dart';

abstract class PastBookingsState extends Equatable {
  const PastBookingsState();
}

class PastBookingsInitial extends PastBookingsState {
  @override
  List<Object?> get props => [];
}

class PastBookingsLoaded extends PastBookingsState {
  final List<BookingListModel> bookings;
  final bool hasReachedMax;
  PastBookingsLoaded({required this.bookings, required this.hasReachedMax});

  @override
  List<Object?> get props => [bookings];
}

class PastBookingsLoading extends PastBookingsState {
  @override
  List<Object?> get props => [];
}

class MorePastBookingsLoading extends PastBookingsState {
  @override
  List<Object?> get props => [];
}

class PastBookingsError extends PastBookingsState {
  final String message;
  PastBookingsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
