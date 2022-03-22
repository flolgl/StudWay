import 'package:flutter/material.dart';
import 'package:studway_project/view/splash.dart';

import 'AppTheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // TODO : fix le darkTheme
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Studway App',
        theme: AppTheme.lightTheme,
        //darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const Splash());
  }
}
