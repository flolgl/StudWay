import 'package:flutter/material.dart';

class CandidatFavList extends StatefulWidget {
  const CandidatFavList({Key? key}) : super(key: key);

  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<CandidatFavList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('FavList'),
    );
  }
}