import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studway_project/view/AppTheme.dart';
import 'package:studway_project/view/login/Register.dart';

import '../../../controller/login/LoginAuth.dart';
import '../../Home.dart';
import '../../icons/social_sign_in_icons_icons.dart';
import '../components/PasswordInput.dart';
import '../components/TextInput.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginBody createState() => LoginBody();
}

class LoginBody extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextInput emailInput = TextInput(text: "Adresse mail", emailValidator: true);
  final PasswordInput passwordInput = PasswordInput(
    text: "Mot de passe",
    isRegister: false,
  );
  String _formErrors = "";

  /// Méthode permettant la construction du form Login
  @override
  Widget build(BuildContext context) {
    // TODO : Connect avec réseaux sociaux
    var gradientDecoration = BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        AppTheme.darkerBlue,
        AppTheme.normalBlue,
      ]),
    );
    return Container(
      width: double.infinity,
      decoration: gradientDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          _buildConnexionText(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: _buildConnexionForm(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Méthode retournant les textes de connexion
  Widget _buildConnexionText() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Connexion",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Bienvenue",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  /// Méthode retournant le form de connexion
  Widget _buildConnexionForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 60,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(39, 58, 105, 3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: emailInput,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: passwordInput,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(child: _buildHrefText(context, "Mot de passe oublié ?", true)),
          const SizedBox(height: 20),
          Text(
            _formErrors != "" ? _formErrors : "",
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(height: _formErrors == "" ? 0 : 20),
          Center(
              child: _buildSubmitButton(
                  "Se connecter", AppTheme.normalBlue, context)),
          const SizedBox(height: 40),
          Center(
              child: _buildHrefText(
                  context, "Pas de compte ? S'enregistrer", false)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              createSocialButton(SocialSignInIcons.github),
              createSocialButton(SocialSignInIcons.linkedin_in),
              createSocialButton(SocialSignInIcons.apple),
            ],
          ),
        ],
      ),
    );
  }

  /// Méthode retournant un button de connexion avec Réseaux Sociaux
  ElevatedButton createSocialButton(IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      child: Icon(
        icon,
        color: AppTheme.normalBlue,
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
    );
  }

  /// Méthode retournant le bouton de submit
  ElevatedButton _buildSubmitButton(
      String text, Color color, BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (await LoginAuth.connect(
              emailInput.getInputText(), passwordInput.getInputText())) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            setState(() {
              _formErrors = "Adresse mail ou mot de passe non reconnu";
            });
          }
        }
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        fixedSize: Size(size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  /// Méthode retournant un text comme un href en html
  Widget _buildHrefText(BuildContext context, String text, bool mdpOublie) {
    // TODO : Hover color + diriger vers mot de passe oublié
    TextStyle linkStyle = TextStyle(color: AppTheme.normalBlue);
    //TextStyle hoverStyle = const TextStyle(color: Color(0xff1d2b43));
    return RichText(
      text: TextSpan(
        style: linkStyle,
        text: text,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            mdpOublie
                ? null
                : Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Register()));
          },
      ),
    );
  }
}
