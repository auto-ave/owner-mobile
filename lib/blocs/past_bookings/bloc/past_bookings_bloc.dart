import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/data/repos/repository.dart';

part 'past_bookings_event.dart';
part 'past_bookings_state.dart';

class PastBookingsBloc extends Bloc<PastBookingsEvent, PastBookingsState> {
  final Repository _repository;
  PastBookingsBloc({required Repository repository})
      : _repository = repository,
        super(PastBookingsInitial()) {
    on<PastBookingsEvent>((event, emit) async {
      if (event is GetPastBookings) {
        await _mapGetPastBookingToState(
            offset: event.offset, forLoadMore: event.forLoadMore, emit: emit);
      }
    });
  }

  bool hasReachedMax(PastBookingsState state, bool forLoadMore) =>
      state is PastBookingsLoaded && state.hasReachedMax && forLoadMore;

  FutureOr<void> _mapGetPastBookingToState(
      {required int offset,
      required bool forLoadMore,
      required Emitter<PastBookingsState> emit}) async {
    if (!hasReachedMax(state, forLoadMore)) {
      print("hellobook");
      try {
        List<BookingListModel> bookings = [];
        if (state is PastBookingsLoaded && forLoadMore) {
          emit(MorePastBookingsLoading());
          bookings = (state as PastBookingsLoaded).bookings;
        } else {
          emit(PastBookingsLoading());
        }

        List<BookingListModel> moreBookings =
            await _repository.getPastBookings(offset: offset);
        emit(PastBookingsLoaded(
            bookings: bookings + moreBookings,
            hasReachedMax:
                moreBookings.length != 10)); //page limit in apiconstants is 10
      } catch (e) {
        emit(PastBookingsError(message: e.toString()));
      }
    }
  }
}
