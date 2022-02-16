import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class LoginAuth {
  static Future<http.Response> register(String email, String password) async {
    var response = await http.post(
      Uri.parse('http://localhost:3000/register'),
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
      Uri.parse('http://localhost:3000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin" : "*",
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    //print(response.body);
    var okToConnect = _isResponseOkForConnecting(response.body);

    if (okToConnect == null)
      return false;

    await FlutterSession().set("token", okToConnect);
    return true;
  }

  static String? _isResponseOkForConnecting(String body){
    if (body.isEmpty)
      return null;

    final parsed = jsonDecode(body) as Map<String, dynamic>;
    if (parsed.containsKey("auth"))
      return parsed["auth"];
    return null;
  }
}
