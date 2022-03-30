import 'package:shared_preferences/shared_preferences.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Candidature {


  // Constructors
  Candidature(this._idCandidature, this._lettreMotivation, this._annonce, this._idUser);

  factory Candidature.fromJson(Map<String, dynamic> json) {
    return Candidature(
      json['idCandidature'],
      json['LettreMotivation'],
      Offer(json['idAnnonce'], json["titre"], json["localisation"], json["Description"], DateTime.parse(json["datePublication"])),
      json["idCandidat"],
    );
  }

  factory Candidature.fromJsonWithOffer(Map<String, dynamic> json, Offer offer) {
    return Candidature(
      json['idCandidature'],
      json['LettreMotivation'],
      offer,
      json["idCandidat"],

    );
  }

  // Fields
  final int _idCandidature;
  final String _lettreMotivation;
  final Offer _annonce;
  final int _idUser;

  int get idCandidature => _idCandidature;
  String get lettreMotivation => _lettreMotivation;
  Offer get annonce => _annonce;
  int get idCandidat => _idUser;
// Methods

  static Future<List<Candidature>> fetchCandidaturesOfOffer(Offer offre) async {
    final prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse("http://localhost:3000/candidatures/annonce/${offre.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token"),
      },
    );

    if (response.statusCode == 200 ) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse as List).map((candidature) => Candidature.fromJsonWithOffer(candidature, offre)).toList();
    }

    return [];
  }


}