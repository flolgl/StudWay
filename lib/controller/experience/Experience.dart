import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Experience{

  final int _id;
  final int _id_user;
  final DateTime _dateDebut;
  final DateTime _dateFin;
  final String _societe;
  final String _poste;
  final String _type;

  Experience(this._id, this._id_user, this._dateDebut,
      this._dateFin, this._societe, this._poste, this._type);

  String get type => _type;

  String get poste => _poste;

  String get societe => _societe;

  DateTime get dateFin => _dateFin;

  DateTime get dateDebut => _dateDebut;

  int get id_user => _id_user;

  int get id => _id;

  static Experience fromJson(Map<String, dynamic> json) {
    return Experience(
      json['idExperience'],
      json['idUtilisateur'],
      DateTime.parse(json['dateDebut']),
      DateTime.parse(json['dateFin']),
      json['Societe'],
      json['Poste'],
      json['Type'],
    );
  }

  static Future<List<Experience>> getExperiencesFromUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse("http://localhost:3000/experience/all/$userId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return (json.decode(response.body) as List)
          .map((data) => Experience.fromJson(data))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return [];
    }
  }

}