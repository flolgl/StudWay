import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studway_project/AppTheme.dart';
import 'package:studway_project/login/components/DoubleConfirmPwInput.dart';
import 'package:studway_project/login/components/PasswordInput.dart';
import 'package:studway_project/login/components/TextInput.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterBody createState() {
    return RegisterBody();
  }
}

class RegisterBody extends State<RegisterForm>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    // TODO : Peut-être rendre le bouton plus rond + mettre le choix entreprise ou non ET la suite appropriée
    return Form(
      key: _formKey,
      child: Row(
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
                const DoubleConfirmPwInput(text: "Mot de passe"),
                /*
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: PasswordInput(text: "Mot de passe")
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: PasswordInput(text: "Confirmer mot de passe")
                ),
                 */
                const SizedBox(height: 14),
                Align(
                    alignment: Alignment.topRight,
                    child: _hyperLinkBuild(context, "Mot de passe oublié ?")
                ),

                const SizedBox(height: 30),
                Align(
                    alignment: Alignment.topRight,
                    child: _buildElevatedButton(AppTheme.lightBlue, context)

                ),



              ],
            ),
          ),
          Expanded(
            flex: 2, // 20%
            child: Container(color: Colors.transparent),
          ),

        ],
      ),
    );
  }

  ElevatedButton _buildElevatedButton(Color color, BuildContext context){
    return ElevatedButton(
      onPressed: () {
        // Validate returns true if the form is valid, or false otherwise.
        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
        }
      },
      child: const Icon(Icons.arrow_forward),
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90.0),
        ),

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