import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../controller/offer/Offer.dart';
import '../../icons/my_flutter_app_icons.dart';

class OfferFullView extends StatefulWidget {
  final Offer _offer;

  const OfferFullView(this._offer, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfferFullViewState(_offer);
}

class _OfferFullViewState extends State<OfferFullView> {
  final Offer _offer;

  _OfferFullViewState(this._offer); //late Future<int> amountOfDaysSinceUpload;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _buildAppBody(),
    );
  }

  Widget _buildAppBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 7),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: _offer.titre,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Icon(
          MyFlutterApp.StudWay_logo_white,
          size: 100.0,
        ),
      ),
    );
  }
}
