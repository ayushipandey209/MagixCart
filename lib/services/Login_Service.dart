import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magixcart/constant/Url.dart';

class LoginService {
  final String baseUrl = Url().baseUrl;

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; 
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error occurred during login: $error');
      return null;
    }
  }
}
