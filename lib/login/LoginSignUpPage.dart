import 'package:flutter/material.dart';
import 'package:studway_project/AppTheme.dart';
import 'package:studway_project/login/Login.dart';

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
              child: _buildElevatedButton("Connexion", const Color(0xff4f6d9c), 1, context),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildElevatedButton("Inscription", const Color(0xff161d2b), 0, context),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xff1d2b43),

    );
  }

  ElevatedButton _buildElevatedButton(String text, Color color, int screen, BuildContext context){
    return ElevatedButton(
      onPressed: (){

          _navigateToScreen(context, screen);

        },
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

  void _navigateToScreen(BuildContext context, int screen) {
    switch (screen){
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));
        break;
      default:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));

    }
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
        theme: AppTheme.lightTheme,
        home: LoginSignUpPage());
  }
}