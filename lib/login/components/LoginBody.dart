import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studway_project/AppTheme.dart';
import 'package:studway_project/icons/social_sign_in_icons_icons.dart';
import 'package:studway_project/login/components/PasswordInput.dart';
import 'package:studway_project/login/components/TextInput.dart';

class LoginBody extends StatelessWidget{
  const LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : Connect avec réseaux sociaux
    var gradientDecoration = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              AppTheme.darkerBlue,
              AppTheme.normalBlue,
            ]
        ),
    );
    return Container(
      width: double.infinity,
      decoration: gradientDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          const SizedBox(height: 80,),
          _buildConnexionText(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: _buildColumnForm(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnexionText() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Connexion", style: TextStyle(color: Colors.white, fontSize: 40),),
          SizedBox(height: 10,),
          Text("Bienvenue", style: TextStyle(color: Colors.white, fontSize: 18),),
        ],
      ),
    );
  }

  Widget _buildColumnForm(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 60,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(39, 58, 105, 3),
                blurRadius: 20,
                offset: Offset(0,10),

              )
            ],
          ),
          child: Column(
            children:<Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!)
                  ),
                ),
                child: const TextInput(text: "Adresse mail"),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: const PasswordInput(text: "Mot de passe"),
              ),

            ],
          ),
        ),
        const SizedBox(height: 40),
        Center(
            child: _hyperLinkBuild(context, "Mot de passe oublié ?")
        ),

        const SizedBox(height: 40),
        Center(
            child: _buildElevatedButton("Se connecter", AppTheme.normalBlue, context)

        ),
        const SizedBox(height: 40),
        Center(
            child: _hyperLinkBuild(context, "Pas de compte ? S'enregistrer")
        ),
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
    );
  }

  ElevatedButton createSocialButton(IconData icon) {
    return ElevatedButton(
      onPressed: () {},
      child: Icon(icon, color: AppTheme.normalBlue,),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),

      ),
    );
  }

  ElevatedButton _buildElevatedButton(String text, Color color, BuildContext context){
    Size size = MediaQuery.of(context).size;

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
        fixedSize: Size(size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _verifyConnexion(BuildContext context) {

  }

  Widget _hyperLinkBuild(BuildContext context, String text) {
    // TODO : Hover color + diriger vers mot de passe oublié
    TextStyle linkStyle = TextStyle(color: AppTheme.normalBlue);
    //TextStyle hoverStyle = const TextStyle(color: Color(0xff1d2b43));
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