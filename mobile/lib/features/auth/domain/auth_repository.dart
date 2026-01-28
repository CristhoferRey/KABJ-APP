import '../data/auth_api.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository({AuthApi? authApi}) : _authApi = authApi ?? AuthApi();

  Future<String> login({required String email, required String password}) {
    return _authApi.login(email: email, password: password);
  }
}
