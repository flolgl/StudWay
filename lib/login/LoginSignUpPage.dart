import 'package:flutter/material.dart';

class LoginSignUpPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/images/studway_blanc_rebords.png"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildElevatedButton("Connexion", Colors.blueAccent),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildElevatedButton("Inscription", Colors.lightBlue),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue,

    );
  }

  ElevatedButton _buildElevatedButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        fixedSize: const Size(700, 50),
      ),
    );
  }



}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Studway App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginSignUpPage());
  }
}