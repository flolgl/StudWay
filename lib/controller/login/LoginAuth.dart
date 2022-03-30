import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginAuth {
  static Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      print("TEST");
      var response = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Authorization": "Bearer " + prefs.getString("token"),
        },
        body: jsonEncode(
          <String, String>{
            'email': email,
            'password': password,
          },
        ),
      );
      print(response.body);
      print(response.statusCode);
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

    final List<dynamic>? token = getToken(response.body);

    if (response.statusCode != 200 || token == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token.elementAt(0));
    prefs.setString("id", token.elementAt(1).toString());
    return true;
  }

  static List<dynamic>? getToken(String body) {
    final parsed = jsonDecode(body) as Map<String, dynamic>;
    return [parsed["accessToken"], parsed["idUtilisateur"]];
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString("token") != null;
    } catch (e) {
      return false;
    }
  }
}
