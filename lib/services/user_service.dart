import 'dart:convert';
import 'package:guias_scouts_mobile/common/token_manager.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:5000/user';

  /// GU-07: Change Password Use Case
  Future<Map<String, dynamic>> login(String prevPassword, String newPassword) async {
    final url = Uri.parse('$baseUrl/change-password');
    final body = {'prevPassword': prevPassword, 'newPassword': newPassword};

    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return responseData;
      } else {
        // Request failed
        return {'error': 'Failed to login. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      // Exception occurred during request
      return {'error': 'Exception occurred: $e'};
    }
  }
}
