import 'dart:convert';

import 'package:http/http.dart' as http;

class Offer {
  final int _id;
  final String _companyName;
  final String _location;
  final String _description;
  final DateTime _uploadDate;

  Offer(this._id, this._companyName, this._location, this._description,
      this._uploadDate);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json['id'],
      json['companyName'],
      json['location'],
      json['description'],
      json['uploadDate'],
    );
  }

  int get id => _id;

  String get companyName => _companyName;

  String get location => _location;

  String get description => _description;

  DateTime get uploadDate => _uploadDate;

  static Future<Offer> fetchOfferInfo() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/offers/1'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Offer.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Impossible de récupérer les données');
      }
    } catch (e) {
      throw Exception('Impossible de récupérer les données');
    }
  }

  /*static Future<int> amountOfTimeSinceUpload() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/offers/1'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var uploadDateToString = json.decode(response.body)['uploadDate'];
        DateTime uploadDate = DateTime.parse(uploadDateToString);
        return DateTime.now().difference(uploadDate).inDays;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Impossible de récupérer les données');
      }
    } catch (e) {
      throw Exception('Impossible de récupérer les données');
    }
  }
  */
}
