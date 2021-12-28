import 'package:owner_app/data/models/auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokensModel> login(
      {required String email,
      required String password,
      required String fcmToken});

  Future<void> logout({required String fcmToken});
}
