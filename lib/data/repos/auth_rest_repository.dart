import 'package:owner_app/data/api/api_methods.dart';
import 'package:owner_app/data/models/auth_tokens.dart';
import 'package:owner_app/data/repos/auth_repository.dart';

class AuthRestRepository implements AuthRepository {
  ApiMethods _apiMethodsImp;
  AuthRestRepository({required ApiMethods apiMethodsImp})
      : _apiMethodsImp = apiMethodsImp;
  @override
  Future<AuthTokensModel> login(
      {required String email,
      required String password,
      required String fcmToken}) async {
    AuthTokensEntity entity = await _apiMethodsImp.login(
        email: email, password: password, fcmToken: fcmToken);
    return AuthTokensModel.fromEntity(entity);
  }

  @override
  Future<void> logout({required String fcmToken}) {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
