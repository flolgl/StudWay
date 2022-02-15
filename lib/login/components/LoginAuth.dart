import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginAuth {
  static Future<http.Response> register(String email, String password) async {
    var response = await http.post(
      Uri.parse('http://localhost:3000/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  static Future<bool> connect(String email, String password) async {
    var response = await http.post(
      Uri.parse('http://localhost:3000/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 201;
  }
}
