import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/offer/Offer.dart';
import '../../../controller/user/User.dart';
import '../../AppTheme.dart';
import '../../icons/my_flutter_app_icons.dart';
import 'ApplyToOffer.dart';

class OfferFullView extends StatefulWidget {
  final User _user;
  final Offer _offer;

  const OfferFullView(this._user, this._offer, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfferFullViewState(_user, _offer);
}

class _OfferFullViewState extends State<OfferFullView> {
  final User _user;
  final Offer _offer;

  _OfferFullViewState(this._user, this._offer); //late Future<int> amountOfDaysSinceUpload;

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
    return SingleChildScrollView(
      reverse: true,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 7),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: _offer.titre,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 15, 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.room,
                    color: Colors.grey,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: _offer.location,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: double.infinity,
                  minHeight: 400,
                  minWidth: 600,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: -7,
                      blurRadius: 15,
                      offset: const Offset(0, 10), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 15,
                    bottom: 15,
                    right: 15,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: _offer.description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 15, 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.grey,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: " " + _offer.timeSinceUploadInDays(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(220, 35),
                    primary: AppTheme.normalBlue,
                    onPrimary: Colors.white,
                    textStyle: const TextStyle(fontSize: 15)),
                child: Row(
                  children: const [
                    Icon(Icons.schedule_send_outlined, size: 28),
                    SizedBox(width: 16),
                    Text("Postuler maintenant"),
                  ],
                ),
                onPressed: () async{
                  if (_user.type == "Entreprise"){
                    return;
                  }

                  if(_offer.lien != "-1") {
                    if (await canLaunch(_offer.lien)) {
                      await launch(_offer.lien);
                      return;
                    }else{
                      _errorPopUp(context, "Impossible d'ouvrir le lien");
                      return;
                    }
                  }

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ApplyToOffer(_user, _offer)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _errorPopUp(BuildContext context, String s) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(s),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
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
