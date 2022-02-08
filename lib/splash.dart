import 'package:flutter/material.dart';
import 'package:studway_project/AppTheme.dart';
import 'Home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()))
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: AppTheme.normalBlue,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/images/logo_white.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Text('StudWay Inc.',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
          ),
        ],
      )),
    );
  }
}
