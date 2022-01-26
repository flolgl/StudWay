import 'package:flutter/material.dart';
import 'package:studway_project/login/components/LoginBody.dart';

class Login extends StatelessWidget{
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context),
      body: const LoginBody(),

    );

  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Connexion",
        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.close_outlined,
          color: Colors.black26,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
    );
  }

}