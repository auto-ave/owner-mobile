import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:owner_app/blocs/global_auth/global_auth_bloc.dart';
import 'package:owner_app/data/local/local_data_service.dart';
import 'package:owner_app/data/models/auth_tokens.dart';
import 'package:owner_app/data/repos/auth_repository.dart';

part 'email_auth_event.dart';
part 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final GlobalAuthBloc _globalAuthBloc;
  final AuthRepository _authRepository;
  final LocalDataService _localDataService;
  EmailAuthBloc(
      {required GlobalAuthBloc globalAuthBloc,
      required AuthRepository authRepository,
      required LocalDataService localDataService})
      : _globalAuthBloc = globalAuthBloc,
        _authRepository = authRepository,
        _localDataService = localDataService,
        super(EmailAuthInitial()) {
    on<EmailAuthEvent>((event, emit) async {
      if (event is Login) {
        await _mapLoginToState(
            email: event.email,
            password: event.password,
            emit: emit,
            fcmToken: event.fcmToken);
      }
    });
  }
  FutureOr<void> _mapLoginToState(
      {required String email,
      required String password,
      required String fcmToken,
      required Emitter<EmailAuthState> emit}) async {
    try {
      emit(EmailAuthLoading());
      AuthTokensModel tokens = await _authRepository.login(
          email: email, password: password, fcmToken: fcmToken);
      if (tokens.authenticated) {
        await _localDataService.storeAuthToken(tokens);
        emit(EmailAuthenticated());
        print('authenticated token');
        _globalAuthBloc.add(YieldAuthenticatedState(tokens: tokens));
      } else {
        emit(WrongCredentials());
      }
    } on DioError catch (e) {
      print('dios err');
      if (e.response != null &&
          (e.response!.statusCode == 400 || e.response!.statusCode == 404)) {
        print('dio err2');
        emit(WrongCredentials());
      }
    } catch (e) {
      emit(EmailAuthError(message: e.toString()));
    }
  }
}
