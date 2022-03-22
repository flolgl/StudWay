import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    final http.Response response;
    try {
      response = await http.post(
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
    } catch (e) {
      return false;
    }

    final String? token = getToken(response.body);

    if (response.statusCode!=200 || token == null)
      return false;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    return true;

  }

  static String? getToken(String body) {
    final parsed = jsonDecode(body) as Map<String, dynamic>;
    return parsed["accessToken"];
  }


  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    try{
      return prefs.getString("token") != null;
    }catch(e) {
      return false;
    }

  }
}
