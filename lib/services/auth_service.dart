import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:5000/auth';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final body = {'email': email, 'password': password};

    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
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
