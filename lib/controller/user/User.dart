import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(

      Uri.parse('http://localhost:3000/users/' + prefs.getString('id')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization" : "Bearer " + prefs.getString("token"),
      },
    );

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

  void updateUserCompetence(String competence) async{
    final prefs = await SharedPreferences.getInstance();

    http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization" : "Bearer " + prefs.getString("token"),
      },
      body: jsonEncode(<String, String>{
        'competence':competence
      }),
    );
  }

  void setUserNewCV() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [ 'pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path);

      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();

      final prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest("POST", Uri.parse("http://localhost:3000/users/cvhandler"));
      request.headers["Authorization"] = "Bearer " + prefs.getString("token");
      request.fields["idUtilisateur"] = id.toString();
      var multipartFile = http.MultipartFile('cvFile', stream, length, filename: basename(file.path));
      request.files.add(multipartFile);
      var response = await request.send();

    } else {
      throw Exception("Err 01: File null");
    }
  }

  void updateUserExperiences(List<DateTime> dates, List<String>texts) async{
    final prefs = await SharedPreferences.getInstance();

    var dateFin = dates.elementAt(1) == dates.elementAt(0) ? "-1" : dates.elementAt(1).millisecondsSinceEpoch.toString();
    http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization" : "Bearer " + prefs.getString("token"),
      },
      body: jsonEncode(<String, String>{
        'dateDebut': dates.elementAt(0).millisecondsSinceEpoch.toString(),
        'dateFin': dateFin,
        'jobName': texts.elementAt(0),
        'entrepriseName': texts.elementAt(1),
      }),
    );

  }

  void updateUserFormation(List<DateTime> dates, List<String>texts) async{

    final prefs = await SharedPreferences.getInstance();

    var dateFin = dates.elementAt(1) == dates.elementAt(0) ? "-1" : dates.elementAt(1).millisecondsSinceEpoch.toString();
    http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization" : "Bearer " + prefs.getString("token"),
      },
      body: jsonEncode(<String, String>{
        'dateDebut': dates.elementAt(0).millisecondsSinceEpoch.toString(),
        'dateFin': dateFin,
        'formationName': texts.elementAt(0),
        'ecoleName': texts.elementAt(1),
      }),
    );

  }
}
