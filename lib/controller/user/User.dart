import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final int _id;
  final int _nbMsg;
  final String _prenom;
  final String _nom;
  final String _email;
  final String _mdp;
  final String _description;
  final String _profilePic;
  final String _cvFile;
  final String _type;

  User(this._id, this._nbMsg, this._prenom, this._nom, this._email, this._mdp,
      this._description, this._profilePic, this._cvFile, this._type);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['nbMsg'],
      json['nom'],
      json['prenom'],
      json['email'],
      json['mdp'],
      json['description'],
      json['profilepic'],
      json['cvfile'],
      json['type'],
    );
  }

  int get id => _id;

  int get nbMsg => _nbMsg;

  String get nom => _nom;

  String get prenom => _prenom;

  String get email => _email;

  String get mdp => _mdp;

  String get description => _description;

  String get profilpic => _profilePic;

  String get cvfile => _cvFile;

  String get type => _type;

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
