import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';
import '../components/AddCompetenceBody.dart';

class CompetenceForm extends StatelessWidget{
  final User _user;
  const CompetenceForm(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: AddCompetenceBody(_user),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: const Center(child: Text("Compétence")),
    );
  }
  
}