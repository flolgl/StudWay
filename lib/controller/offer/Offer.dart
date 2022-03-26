import 'dart:convert';

import 'package:http/http.dart' as http;

class Offer {
  final int _idAnnonce;
  final String _companyName;
  final String _location;
  final String _description;
  final DateTime _uploadDate;

  Offer(this._idAnnonce, this._companyName, this._location, this._description,
      this._uploadDate);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json['idAnnonce'],
      json['titre'],
      json['localisation'],
      json['Description'],
      DateTime.parse(json['datePublication']),
    );
  }

  int get id => _idAnnonce;

  String get companyName => _companyName;

  String get location => _location;

  String get description => _description;

  DateTime get uploadDate => _uploadDate;

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
    try {
      final response = await http
          .get(Uri.parse("http://localhost:3000/annonce/motsClefs/:" + keyword));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<int> fetchedOfferList = [];
        final responseLength = json.decode(response.body);
        for(int i = 0; i < responseLength.length - 1; i++){
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

  int timeSinceUploadInDays() {
    var timeSinceUploadInDays = DateTime.now().difference(uploadDate).inDays;
    return timeSinceUploadInDays;
  }
}
