import 'package:flutter/material.dart';
import 'package:studway_project/splash.dart';

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
        home: Splash());
  }
}
