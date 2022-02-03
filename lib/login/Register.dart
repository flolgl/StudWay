import 'package:flutter/material.dart';
import '../AppTheme.dart';
import 'components/RegisterBody.dart';

class Register extends StatelessWidget{
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: RegisterForm(),

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
        debugShowCheckedModeBanner: false,
        home: const Register());
  }
}