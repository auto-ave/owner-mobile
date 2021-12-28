import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owner_app/data/local/local_data_service.dart';
import 'package:owner_app/data/models/auth_tokens.dart';

part 'global_auth_event.dart';
part 'global_auth_state.dart';

class GlobalAuthBloc extends Bloc<GlobalAuthEvent, GlobalAuthState> {
  final LocalDataService _localDataService;
  GlobalAuthBloc({required LocalDataService localDataService})
      : _localDataService = localDataService,
        super(GlobalAuthInitial()) {
    on<GlobalAuthEvent>((event, emit) async {
      if (event is AppStarted || event is CheckAuthStatus) {
        await _mapAppStartedtoState(emit);
      } else if (event is YieldAuthenticatedState) {
        await _mapYieldAuthenticatedStateToState(
            tokens: event.tokens, emit: emit);
      }
    });
  }

  // @override
  // Stream<GlobalAuthState> mapEventToState(
  //   GlobalAuthEvent event,
  // ) async* {
  //   if (event is AppStarted || event is CheckAuthStatus) {
  //     yield* _mapAppStartedtoState();
  //   } else if (event is YieldAuthenticatedState) {
  //     yield* _mapYieldAuthenticatedStateToState(tokens: event.tokens);
  //   }
  // }

  FutureOr<void> _mapAppStartedtoState(Emitter<GlobalAuthState> emit) async {
    try {
      emit(CheckingAuthStatus());
      AuthTokensModel tokens = await _localDataService.getAuthTokens();
      if (tokens.authenticated) {
        emit(Authenticated(tokens: tokens));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(GlobalAuthError(message: e.toString()));
    }
  }

  FutureOr<void> _mapYieldAuthenticatedStateToState(
      {required AuthTokensModel tokens,
      required Emitter<GlobalAuthState> emit}) async {
    print('yield authen called');
    emit(Authenticated(tokens: tokens));
  }
}
