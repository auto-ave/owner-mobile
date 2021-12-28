import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:owner_app/data/repos/repository.dart';

part 'start_complete_service_event.dart';
part 'start_complete_service_state.dart';

class StartCompleteServiceBloc
    extends Bloc<StartCompleteServiceEvent, StartCompleteServiceState> {
  final Repository _repository;
  StartCompleteServiceBloc({required Repository repository})
      : _repository = repository,
        super(StartCompleteServiceInitial()) {
    on<StartCompleteServiceEvent>((event, emit) async {
      if (event is StartService) {
        await _mapStartServiceToState(
            bookingId: event.bookingId, otp: event.otp, emit: emit);
      } else if (event is CompleteService) {
        await _mapCompleteServiceToState(
            bookingId: event.bookingId, emit: emit);
      }
    });
  }

  FutureOr<void> _mapStartServiceToState(
      {required String bookingId,
      required String otp,
      required Emitter<StartCompleteServiceState> emit}) async {
    try {
      emit(StartingService());
      var data = await _repository.startService(bookingId: bookingId, otp: otp);
      emit(ServiceStarted());
    } on DioError catch (e) {
      print('dio err');
      if (e.response != null && e.response!.statusCode == 400) {
        print('dio err2');
        emit(WrongOTPEntered());
      }
    } catch (e) {
      emit(StartServiceError(message: e.toString()));
    }
  }

  FutureOr<void> _mapCompleteServiceToState(
      {required String bookingId,
      required Emitter<StartCompleteServiceState> emit}) async {
    try {
      emit(CompletingService());
      var data = await _repository.completeService(bookingId: bookingId);
      emit(ServiceCompleted());
    } catch (e) {
      emit(CompleteServiceError(message: e.toString()));
    }
  }
}
