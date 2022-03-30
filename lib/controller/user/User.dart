import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studway_project/controller/candidature/Candidature.dart';
import 'package:studway_project/controller/conversation/Conversation.dart';
import 'package:studway_project/controller/offer/Offer.dart';

class User {
  static User? currentUser;
  final int _id;
  final int _nbMsg;
  final String _prenom;
  final String _nom;
  final String _email;
  String _description;
  final String _cvFile;
  final String _type;
  late IO.Socket _socket;

  List<Conversation>? _conversations;

  User(this._id, this._nbMsg, this._prenom, this._nom, this._email,
      this._description, this._cvFile, this._type) {
    connectUserToSocket();
    getUpdatedConversations();
    currentUser = this;
  }

  User.strict(this._id, this._nbMsg, this._prenom, this._nom, this._email,
      this._description, this._cvFile, this._type);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['idUtilisateur'],
      json['nbMsg'],
      json['prenom'] ?? '',
      json['nom'],
      json['email'],
      json['Description'] ?? '',
      json['CVFile'] ?? '',
      json['Type'],
    );


  }

  factory User.strictFromJson(Map<String, dynamic> json) {
    print(json);
    return User.strict(
      json['idUtilisateur'],
      -1,
      json['Prenom'] ?? "",
      json['Nom'] ?? "",
      "",
      "",
      "",
      "",
    );
  }

  int get id => _id;

  int get nbMsg => _nbMsg;

  String get nom => _nom;

  String get prenom => _prenom;

  String get email => _email;

  String get description => _description;

  String get profilpic => "http://localhost:3000/users/photoprofile/$_id";

  String get cvfile => _cvFile;

  String get type => _type;

  List<Conversation>? get conversations => _conversations;

  IO.Socket get socket => _socket;

  void connectUserToSocket() {
    print("connecting user to socket");
    _socket = IO.io('http://localhost:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();
    _socket.emit("identification", {"userId": _id});
  }

  void sendNewMsg(int convId, int to, String content) {
    _socket.emit("newMsg",
        {"to": to, "content": content, "convId": convId, "from": _id});
  }

  /// Get the list of conversations
  /// @return the list of conversations
  /// @throws Exception if the list of conversations is null or empty
  Future<List<Conversation>> getUpdatedConversations() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('http://localhost:3000/conversation/utilisateur/' +
          prefs.getString('id')!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return await Conversation.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Failed to load conversation');
    }
  }

  /// Get minimal user from api
  /// @return [User] the limited user
  /// @throws Exception if the user is null
  static Future<User> fetchStrictUserInfo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    print("fetching user info for id : " + id.toString());
    final response = await http.get(
      Uri.parse('http://localhost:3000/users/public/' + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.strictFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Impossible de récupérer les données');
    }
  }

  /// Get a user from api
  /// @return [User] the user
  /// @throws Exception if the user is null
  static Future<User> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('http://localhost:3000/users/' + prefs.getString('id')!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Impossible de récupérer les données');
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      print("erreur");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Impossible de récupérer les données');
    }
  }

  /// Add a competence to the user
  /// @param [String] the competence
  void updateUserCompetence(String competence) async {
    final prefs = await SharedPreferences.getInstance();

    http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: jsonEncode(<String, String>{'competence': competence}),
    );
  }

  /// Add a competence to the user
  /// @param [String] the competence
  void updateUserDescription(String description) async {
    final prefs = await SharedPreferences.getInstance();

    await http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: jsonEncode(<String, String>{'Description': description}),
    );
    _description = description;
  }

  /// Add a cv to the user
  void setUserNewCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);

      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();

      final prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest(
          "POST", Uri.parse("http://localhost:3000/users/cvhandler"));
      request.headers["Authorization"] = "Bearer " + prefs.getString("token")!;
      request.fields["idUtilisateur"] = id.toString();
      var multipartFile = http.MultipartFile('cvFile', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
      var response = await request.send();
    } else {
      throw Exception("Err 01: File null");
    }
  }

  /// Add a competence to the user
  /// @param [List<DateTime>] starting date as the first element and the ending date as the second element (if first element == second element, job hasn't stopped yet)
  /// @param [List<String>] job name as the first element and the company name as the second element
  void updateUserExperiences(List<DateTime> dates, List<String> texts) async {
    final prefs = await SharedPreferences.getInstance();

    var dateFin = dates.elementAt(1) == dates.elementAt(0)
        ? "-1"
        : dates.elementAt(1).millisecondsSinceEpoch.toString();
    http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: jsonEncode(<String, String>{
        'dateDebut': dates.elementAt(0).millisecondsSinceEpoch.toString(),
        'dateFin': dateFin,
        'jobName': texts.elementAt(0),
        'entrepriseName': texts.elementAt(1),
      }),
    );
  }

  /// Add a formation to the user
  /// @param [List<DateTime>] starting date as the first element and the ending date as the second element (if first element == second element, job hasn't stopped yet)
  /// @param [List<String>] formation name as the first element and the school name as the second element
  void updateUserFormation(List<DateTime> dates, List<String> texts) async {
    final prefs = await SharedPreferences.getInstance();

    var dateFin = dates.elementAt(1) == dates.elementAt(0)
        ? "-1"
        : dates.elementAt(1).millisecondsSinceEpoch.toString();
    http.post(
      Uri.parse("http://localhost:3000/users/update/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: jsonEncode(<String, String>{
        'dateDebut': dates.elementAt(0).millisecondsSinceEpoch.toString(),
        'dateFin': dateFin,
        'formationName': texts.elementAt(0),
        'ecoleName': texts.elementAt(1),
      }),
    );
  }

  void createNewOffer(
      String jobTitle, String location, String description) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      http.post(
        Uri.parse("http://localhost:3000/annonce/create/" + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Authorization": "Bearer " + prefs.getString("token")!,
        },
        body: jsonEncode(
          <String, String>{
            'idEntreprise': id.toString(),
            'titre': jobTitle,
            'localisation': location,
            'description': description,
          },
        ),
      );
    } catch (e) {
      print(e.toString());
      throw Exception;
    }
  }

  /// Return user's offers fav list
  Future<List<Offer>> fetchCandidatFav() async {
    final prefs = await SharedPreferences.getInstance();
    return http.get(
      Uri.parse("http://localhost:3000/annonce/favoris/" + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    ).then((http.Response response) {
      if (response.statusCode != 200) {
        throw Exception("Err 02: Fetch failed");
      }

      List<Offer> list = <Offer>[];
      // print(response.body);
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        list.add(Offer.fromJson(data[i]));
      }
      return list;
    });
  }

  Future<bool> deleteFav(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("http://localhost:3000/annonce/deleteFav/" +
          id.toString() +
          "/" +
          _id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  Future<bool> addFav(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("http://localhost:3000/annonce/addFav/" +
          id.toString() +
          "/" +
          _id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      }
    );
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  Future<List<Candidature>> fetchCandidature() async {
    final prefs = await SharedPreferences.getInstance();

    return http.get(
      Uri.parse("http://localhost:3000/candidatures/candidat/" + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    ).then((http.Response response) {
      if (response.statusCode != 200) {
        throw Exception("Err 04: Fetch failed");
      }

      List<Candidature> list = <Candidature>[];
      // print(response.body);
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        list.add(Candidature.fromJson(data[i]));
      }
      return list;
    });
  }

  Future<bool> deleteCandidature(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("http://localhost:3000/candidatures/delete/" +
          id.toString() +
          "/" +
          _id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  static Future<User> fetchUserInfoByID(int id) async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost:3000/users/" + id.toString()));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return User.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Status code != 200');
      }
    } catch (e) {
      throw Exception('caught http error');
    }
  }


  Future<bool> applyTo(
      Offer offer, String lettreMotivation, String warningMessage) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var request = await http.post(
        Uri.parse("http://localhost:3000/candidature/create"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Authorization": "Bearer " + prefs.getString("token")!,
        },
        body: jsonEncode(
          <String, String>{
            'idAnnonce': offer.id.toString(),
            'idCandidat': id.toString(),
            'CVFile': _cvFile,
            'LettreMotivation': lettreMotivation,
          },
        ),
      );

      if (request.statusCode == 403) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }
}
