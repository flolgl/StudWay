import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studway_project/controller/user/User.dart';

class Offer {
  final int _idAnnonce;
  final String _titre;
  final String _location;
  final String _description;
  final DateTime _uploadDate;
  final int _userId;
  final String _lien;

  Offer(this._idAnnonce, this._titre, this._location, this._description,
      this._uploadDate, this._userId, this._lien);

  factory Offer.fromJson(Map<String, dynamic> json) {
    print(json);
    return Offer(
      json['idAnnonce'],
      json['titre'],
      json['localisation'],
      json['Description'],
      DateTime.parse(json['datePublication']),
      json['idEntreprise'],
      json['lien'],
    );
  }

  int get id => _idAnnonce;

  String get titre => _titre;

  String get lien => _lien;

  String get location => _location;

  String get description => _description;

  DateTime get uploadDate => _uploadDate;

  int get entrepriseId => _userId;

  static Future<Offer> fetchOfferInfoByID(int id) async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost:3000/annonce/" + id.toString()));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Offer.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Status code != 200');
      }
    } catch (e) {
      throw Exception('caught http error');
    }
  }

  static Future<List<int>> fetchOffersByKeyword(String keyword) async {
    keyword = keyword.replaceAll(' ', ';');
    String url = "http://localhost:3000/annonce/motsClefs/" + keyword;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<int> fetchedOfferList = [];
        final responseLength = json.decode(response.body);
        for (int i = 0; i < responseLength.length; i++) {
          fetchedOfferList.add(jsonDecode(response.body)[i]['idAnnonce']);
        }
        return fetchedOfferList;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Status code != 200');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('caught http error');
    }
  }

  String timeSinceUploadInDays() {
    var timeSinceUploadInDays = DateTime.now().difference(uploadDate).inDays;
    return timeSinceUploadInDays == 0
        ? "Aujourd'hui"
        : "Il y a " + timeSinceUploadInDays.toString() + " jours";
  }

  static Future<List<int>> fetchAllOffersInfo() async {
    try {
      final response =
          await http.get(Uri.parse("http://localhost:3000/annonces/all")).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Impossible de récupérer les données');
            },
          );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<int> fetchedOfferList = [];
        final responseLength = json.decode(response.body);
        for (int i = 0; i < responseLength.length; i++) {
          fetchedOfferList.add(jsonDecode(response.body)[i]['idAnnonce']);
        }
        return fetchedOfferList;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Status code != 200');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('caught http error');
    }
  }


  static Future<List<Offer>> fetchAllAnnonceOfEntreprise(int id) async{
    final prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse("http://localhost:3000/annonces/user/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );

    if(response.statusCode != 200 && response.statusCode != 404 ){
      throw Exception("Err 05: Fetch failed");
    }

    List<Offer> list = <Offer>[];
    final responseLength = json.decode(response.body);
    for (int i = 0; i < responseLength.length; i++) {
      list.add(Offer.fromJson(jsonDecode(response.body)[i]));
    }
    return list;

  }


  // TODO : delete offer (cascade delete et tout en bdd + verif user = proprietaire annonce)
  static Future<bool> deleteUserOffer(int id) async{
    final prefs = await SharedPreferences.getInstance();

    var response = await http.delete(
      Uri.parse("http://localhost:3000/annonce/$id/${User.currentUser!.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );

    if(response.statusCode != 200 ){
      return false;
    }

    return true;
  }


}
