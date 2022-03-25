import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/Home/Profile/components/AddExperienceBody.dart';
import '../components/AddFormationBody.dart';

class ExperienceForm extends StatelessWidget{
  final User _user;
  const ExperienceForm(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: AddExperienceBody(_user),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: const Center(child: Text("Experience")),
    );
  }
  
}