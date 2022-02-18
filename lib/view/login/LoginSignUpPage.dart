import 'package:flutter/material.dart';
import 'package:studway_project/view/AppTheme.dart';
import './Login.dart';
import './Register.dart';

class LoginSignUpPage extends StatelessWidget{
  const LoginSignUpPage({Key? key}) : super(key: key);


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
              child: _buildElevatedButton("Connexion", AppTheme.lightBlue, AppTheme.darkerBlue, 1, context),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildElevatedButton("Inscription", AppTheme.darkerBlue, AppTheme.lightBlue, 0, context),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xfff2f5f7),

    );
  }

  ElevatedButton _buildElevatedButton(String text, Color color, Color textColor, int screen, BuildContext context){
    return ElevatedButton(
      onPressed: (){

          _navigateToScreen(context, screen);

        },
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color:textColor),
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Register()));

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
        home: const LoginSignUpPage());
  }
}