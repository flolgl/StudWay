import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final int _id;
  final int _nbMsg;
  final String _prenom;
  final String _nom;
  final String _email;
  final String _description;
  final String _profilePic;
  final String _cvFile;

  User(this._id, this._nbMsg, this._prenom, this._nom, this._email,
      this._description, this._profilePic, this._cvFile);

  factory User.fromJson(Map<String, dynamic> json) {
    //print(json);
    return User(
      json['idUtilisateur'],
      json['nbMsg'],
      json['Nom'],
      json['Prenom'],
      json['Email'],
      json['Description'],
      json['PhotoProfile'],
      json['CVFile'],
    );
  }

  int get id => _id;

  int get nbMsg => _nbMsg;

  String get nom => _nom;

  String get prenom => _prenom;

  String get email => _email;

  String get description => _description;

  String get profilpic => _profilePic;

  String get cvfile => _cvFile;


  static Future<User> fetchUserInfo() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/users/1'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return User.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Impossible de récupérer les données');
      }
    } catch (e) {
      throw Exception('Impossible de récupérer les données');
    }
  }
}
