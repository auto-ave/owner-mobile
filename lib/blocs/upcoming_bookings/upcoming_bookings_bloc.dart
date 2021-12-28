import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/data/repos/repository.dart';

part 'upcoming_bookings_event.dart';
part 'upcoming_bookings_state.dart';

class UpcomingBookingsBloc
    extends Bloc<UpcomingBookingsEvent, UpcomingBookingsState> {
  final Repository _repository;
  UpcomingBookingsBloc({required Repository repository})
      : _repository = repository,
        super(UpcomingBookingsInitial()) {
    on<UpcomingBookingsEvent>((event, emit) async {
      if (event is GetUpcomingBookings) {
        await _mapGetUpcomingBookingToState(
            offset: event.offset, forLoadMore: event.forLoadMore, emit: emit);
      }
    });
  }

  bool hasReachedMax(UpcomingBookingsState state, bool forLoadMore) =>
      state is UpcomingBookingsLoaded && state.hasReachedMax && forLoadMore;

  FutureOr<void> _mapGetUpcomingBookingToState(
      {required int offset,
      required bool forLoadMore,
      required Emitter<UpcomingBookingsState> emit}) async {
    if (!hasReachedMax(state, forLoadMore)) {
      print("hellobook");
      try {
        List<BookingListModel> bookings = [];
        if (state is UpcomingBookingsLoaded && forLoadMore) {
          emit(MoreUpcomingBookingsLoading());
          bookings = (state as UpcomingBookingsLoaded).bookings;
        } else {
          emit(UpcomingBookingsLoading());
        }

        List<BookingListModel> moreBookings =
            await _repository.getUpcomingBookings(offset: offset);
        emit(UpcomingBookingsLoaded(
            bookings: bookings + moreBookings,
            hasReachedMax:
                moreBookings.length != 10)); //page limit in apiconstants is 10
      } catch (e) {
        emit(UpcomingBookingsError(message: e.toString()));
      }
    }
  }
}
