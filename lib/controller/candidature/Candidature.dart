import 'package:studway_project/controller/offer/Offer.dart';

class Candidature {


  // Constructors
  Candidature(this._idCandidature, this._lettreMotivation, this._annonce);

  factory Candidature.fromJson(Map<String, dynamic> json) {
    return Candidature(
      json['idCandidature'],
      json['LettreMotivation'],
      Offer(json['idAnnonce'], json["titre"], json["localisation"], json["Description"], DateTime.parse(json["datePublication"])),
    );
  }

  // Fields
  final int _idCandidature;
  final String _lettreMotivation;
  final Offer _annonce;

  int get idCandidature => _idCandidature;
  String get lettreMotivation => _lettreMotivation;
  Offer get annonce => _annonce;
// Methods

}