import 'package:shared_preferences/shared_preferences.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:studway_project/controller/user/User.dart';

class Candidature {


  // Constructors
  Candidature(this._idCandidature, this._lettreMotivation, this._annonce, this._idUser, this._retenue);

  factory Candidature.fromJson(Map<String, dynamic> json) {
    return Candidature(
      json['idCandidature'],
      json['LettreMotivation'],
      Offer(json['idAnnonce'], json["titre"], json["localisation"], json["Description"], DateTime.parse(json["datePublication"]), json['idEntreprise'], json["lien"]),
      json["idCandidat"],
      json["retenue"],
    );
  }

  factory Candidature.fromJsonWithOffer(Map<String, dynamic> json, Offer offer) {
    return Candidature(
      json['idCandidature'],
      json['LettreMotivation'],
      offer,
      json["idCandidat"],
      json["retenue"],
    );
  }

  // Fields
  final int _idCandidature;
  final String _lettreMotivation;
  final Offer _annonce;
  final int _idUser;
  int _retenue; // -1 si non vue, 0 si refusée, 1 si acceptée

  int get idCandidature => _idCandidature;
  String get lettreMotivation => _lettreMotivation;
  Offer get annonce => _annonce;
  int get idCandidat => _idUser;
  int get retenue => _retenue;

  set retenue(int value) {
    _retenue = value;
  }
  // Methods

  static Future<List<Candidature>> fetchCandidaturesNotRefusedOfOffer(Offer offre) async {
    final prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse("http://localhost:3000/candidatures/annonce/notRefused/${offre.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );

    if (response.statusCode == 200 ) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse as List).map((candidature) => Candidature.fromJsonWithOffer(candidature, offre)).toList();
    }

    return [];
  }

  static Future<List<Candidature>> fetchAllCandidaturesOfOffer(Offer offre) async {
    final prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse("http://localhost:3000/candidatures/annonce/${offre.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
    );

    if (response.statusCode == 200 ) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse as List).map((candidature) => Candidature.fromJsonWithOffer(candidature, offre)).toList();
    }

    return [];
  }

  Future<bool> setRetenueState(int state) async{
    final prefs = await SharedPreferences.getInstance();

    if(state != 0 && state != 1){
      return false;
    }

    var response = http.put(
      Uri.parse("http://localhost:3000/candidatures/$idCandidature/retenir/${User.currentUser!.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: jsonEncode(
        <String, String>{
          "candidatureNewState": "$state",
        },
      ),
    );

    return response.then((response) {
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    });
  }


}