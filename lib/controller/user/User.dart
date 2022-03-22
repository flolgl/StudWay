import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int _id;
  final int _nbMsg;
  final String _prenom;

  User(this._id, this._nbMsg, this._prenom);

  factory User.fromJson(Map<String, dynamic> json) {
    //print(json);
    return User(
      json['id'],
      json['nbMsg'],
      json['Prenom'],
    );
  }

  int get id => _id;

  int get nbMsg => _nbMsg;

  String get prenom => _prenom;


  static Future<User> fetchUserInfo() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/users/1'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return User.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Impossible de récupérer les données');
      }
    }
    catch (e) {
      throw Exception('Impossible de récupérer les données');
    }
  }

}
