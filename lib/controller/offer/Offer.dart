import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  static void createNewOffer(String jobTitle, String location, String description/*, Image image*/) async {
    final prefs = await SharedPreferences.getInstance();
    http.post(
      Uri.parse("http://localhost:3000/annonce/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer " + prefs.getString("token"),
      },
      body: jsonEncode(
        <String, String>{
          'titre': jobTitle,
          'location': location,
          'Description': description,
        },
      ),
    );
  }
}
