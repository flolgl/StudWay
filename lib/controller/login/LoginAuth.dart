import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class LoginAuth {
  static Future<bool> register(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> connect(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      var okToConnect = _isResponseOkForConnecting(response.body);

      if (okToConnect == null) return false;

      await FlutterSession().set("token", okToConnect);
      return true;
    } catch (e) {
      return false;
    }
    //print(response.body);
  }

  static String? _isResponseOkForConnecting(String body) {
    if (body.isEmpty) return null;

    final parsed = jsonDecode(body) as Map<String, dynamic>;
    if (parsed.containsKey("auth")) return parsed["auth"];
    return null;
  }
}