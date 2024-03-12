import 'package:guias_scouts_mobile/services/user_service.dart';

enum ChangePasswordResponse {
  SUCCESS,
  INVALID_PASSWORD,
  SERVER_ERROR
}

class UserController {
  final UserService service = UserService();

  Future<ChangePasswordResponse> changePassword(String email, String password) async {
    try {
      final response = await service.login(email, password);

      if (response.containsKey('error')) {
        return ChangePasswordResponse.SERVER_ERROR;
      }

      if (response['status'] != 200) {
        return ChangePasswordResponse.INVALID_PASSWORD;
      }

      return ChangePasswordResponse.SUCCESS;
    } catch (e) {
      // Exception occurred during request
      return ChangePasswordResponse.SERVER_ERROR;
    }
  }
}
