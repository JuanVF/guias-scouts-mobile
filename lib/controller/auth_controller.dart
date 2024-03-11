import 'dart:convert';
import 'package:guias_scouts_mobile/common/token_manager.dart';
import 'package:guias_scouts_mobile/services/auth_service.dart';

enum LoginResponse {
  NEEDS_CONFIRMATION,
  SUCCESS,
  INVALID_CREDENTIALS,
  SERVER_ERROR
}

class AuthController {
  final AuthService service = AuthService();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await service.login(email, password);

      if (response.containsKey('error')) {
        return LoginResponse.SERVER_ERROR;
      }

      if (response['status'] == 401) {
        return LoginResponse.INVALID_CREDENTIALS;
      }

      if (response.containsKey('redirect')) {
        return LoginResponse.NEEDS_CONFIRMATION;
      }

      TokenManager.storeToken(response['body']['token']);

      return LoginResponse.SUCCESS;
    } catch (e) {
      // Exception occurred during request
      return LoginResponse.SERVER_ERROR;
    }
  }
}
