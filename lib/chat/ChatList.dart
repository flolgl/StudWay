import 'package:flutter/material.dart';
import 'package:studway_project/chat/components/Body.dart';


class ChatList extends StatelessWidget{



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );


  }

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
