part of 'email_auth_bloc.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();
}

class EmailAuthInitial extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthenticated extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class WrongCredentials extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthError extends EmailAuthState {
  final String message;
  const EmailAuthError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
