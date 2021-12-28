import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/data/repos/repository.dart';
import 'package:rxdart/rxdart.dart';

part 'all_bookings_event.dart';
part 'all_bookings_state.dart';

class AllBookingsBloc extends Bloc<AllBookingsEvent, AllBookingsState> {
  final Repository _repository;
  AllBookingsBloc({required Repository repository})
      : _repository = repository,
        super(AllBookingsInitial()) {
    on<AllBookingsEvent>(_onEvent, transformer: switchMapTransformer());
  }

  FutureOr<void> _mapGetSlotsToState({
    required DateTime date,
    required Emitter<AllBookingsState> emit,
  }) async {
    try {
      // print('Loading FOR' + date.toString());

      // yield LoadingSlots();
      emit(AllBookingsLoading());
      List<BookingListModel> bookings =
          await _repository.getBookingsByDate(date: date);
      // print('SLOTS LOADED FOR' + date.toString());
      // yield SlotsLoaded(slots: slots);
      emit(AllBookingsLoaded(bookings: bookings));
    } catch (e) {
      // yield AllBookingsError(message: e.toString());
      emit(AllBookingsError(message: e.toString()));
    }
  }

  FutureOr<void> _onEvent(
      AllBookingsEvent event, Emitter<AllBookingsState> emit) async {
    if (event is GetAllBookingsByDate) {
      await _mapGetSlotsToState(date: event.date, emit: emit);
    }
  }
}

EventTransformer<AllBookingsEvent> switchMapTransformer() {
  return (events, mapper) => events.switchMap(mapper);
}
