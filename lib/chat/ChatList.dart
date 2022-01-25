import 'package:flutter/material.dart';
import 'package:studway_project/chat/components/Body.dart';

/// Classe permettant d'afficher la page Messages d'un user
class ChatList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Messages"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],

    );
  }

}
