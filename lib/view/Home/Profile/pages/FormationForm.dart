import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';
import '../components/AddFormationBody.dart';

class FormationForm extends StatelessWidget{
  final User _user;
  const FormationForm(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: AddFormationBody(_user),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: const Center(child: Text("Formation")),
    );
  }
  
}