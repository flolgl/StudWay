import 'package:flutter/material.dart';
import 'package:studway_project/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Studway App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Splash());
  }
}
