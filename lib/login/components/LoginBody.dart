import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studway_project/login/components/PasswordInput.dart';
import 'package:studway_project/login/components/TextInput.dart';

class LoginBody extends StatelessWidget{
  const LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : Peut-être changer le max size du button Se connecter
    return Row(
      children: [
        Expanded(
          flex: 2, // 20%
          child: Container(color: Colors.transparent),
        ),

        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TextInput(text: "Adresse mail")
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: PasswordInput(text: "Mot de passe")
              ),
              const SizedBox(height: 14),
              Align(
                  alignment: Alignment.topRight,
                  child: _hyperLinkBuild(context, "Mot de passe oublié ?")
              ),

              const SizedBox(height: 30),
              Center(
                  child: _buildElevatedButton("Se connecter", const Color(0xff4f6d9c), context)

              ),



            ],
          ),
        ),
        Expanded(
          flex: 2, // 20%
          child: Container(color: Colors.transparent),
        ),

      ],
    );
  }

  ElevatedButton _buildElevatedButton(String text, Color color, BuildContext context){
    return ElevatedButton(
      onPressed: (){

        _verifyConnexion(context);

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

  void _verifyConnexion(BuildContext context) {

  }

  Widget _hyperLinkBuild(BuildContext context, String text) {
    // TODO : Hover color + diriger vers mot de passe oublié
    TextStyle linkStyle = const TextStyle(color: Color(0xff4f6d9c));
    TextStyle hoverStyle = const TextStyle(color: Color(0xff1d2b43));
    return RichText(
      text: TextSpan(
        style: linkStyle,
        text: text,

        recognizer: TapGestureRecognizer()
          ..onTap = () {
            print(text);
          },
      ),
    );
  }

}