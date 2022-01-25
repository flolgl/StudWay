import 'package:flutter/material.dart';

class ChatList extends StatelessWidget{



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
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