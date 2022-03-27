import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';

import '../../../controller/offer/Offer.dart';
import 'AddOfferBody.dart';

class OfferForm extends StatelessWidget{
  const OfferForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: AddOfferBody(),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: const Center(child: Text("Formation")),
    );
  }

}