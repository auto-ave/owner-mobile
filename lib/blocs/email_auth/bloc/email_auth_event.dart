part of 'email_auth_bloc.dart';

abstract class EmailAuthEvent extends Equatable {
  const EmailAuthEvent();
}

class Login extends EmailAuthEvent {
  final String email;
  final String password;
  final String fcmToken;
  const Login(
      {required this.email, required this.password, required this.fcmToken});
  @override
  List<Object> get props => [email, password, fcmToken];
}
