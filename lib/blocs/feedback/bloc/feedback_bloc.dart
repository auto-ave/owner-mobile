import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:owner_app/data/repos/repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final Repository _repository;
  FeedbackBloc({required Repository repository})
      : _repository = repository,
        super(FeedbackInitial()) {
    on((event, emit) async {
      if (event is SendFeedback) {
        await _mapSendFeedbackToState(
            phoneNumber: event.phone,
            email: event.email,
            message: event.message,
            emit: emit);
      }
    });
  }

  Stream<FeedbackState> _mapSendFeedbackToState(
      {required String phoneNumber,
      required String email,
      required String message,
      required Emitter emit}) async* {
    try {
      emit(FeedbackLoading());
      await _repository.sendFeedback(
          email: email, phoneNumber: phoneNumber, message: message);
      emit(FeedbackSent());
    } catch (e) {
      emit(FeedbackError(message: e.toString()));
    }
  }
}
