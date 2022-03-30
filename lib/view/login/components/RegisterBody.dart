import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import './TextInput.dart';
import '../../../controller/login/LoginAuth.dart';
import '../../AppTheme.dart';
import '../../icons/social_sign_in_icons_icons.dart';
import '../Login.dart';
import 'DoubleConfirmPwInput.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterBody createState() => RegisterBody();
}

enum UserType { company, candidate }

class RegisterBody extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  UserType? _currentType = UserType.candidate;

  final firstNameInput = TextInput(
    text: "Prénom",
    emailValidator: false,
  );

  final lastNameInput = TextInput(
    text: "Nom",
    emailValidator: false,
  );

  final emailInput = TextInput(
    text: "Adresse mail",
    emailValidator: true,
  );
  final pwInput = DoubleConfirmPwInput(text: "Mot de passe");
  final descriptionInput = TextInput(
    text: "Description",
    emailValidator: false,
  );
  bool visibility = true;

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
                      topRight: Radius.circular(60))),
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
          Text(
            "S'enregistrer",
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

  Widget _buildColumnForm(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Entreprise'),
          leading: Radio<UserType>(
            activeColor: AppTheme.normalBlue,
            value: UserType.company,
            groupValue: _currentType,
            onChanged: (UserType? value) {
              setState(
                () {
                  _currentType = value;
                  visibility = false;
                },
              );
            },
          ),
        ),
        ListTile(
          title: const Text('Candidat'),
          leading: Radio<UserType>(
            activeColor: AppTheme.normalBlue,
            value: UserType.candidate,
            groupValue: _currentType,
            onChanged: (UserType? value) {
              setState(() {
                _currentType = value;
                visibility = true;
              });
            },
          ),
        ),
        Form(
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
                    Visibility(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!)),
                        ),
                        child: firstNameInput,
                      ),
                      visible: visibility,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      child: lastNameInput,
                    ),
                    Visibility(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!)),
                        ),
                        child: descriptionInput,
                      ),
                      visible: visibility,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      child: emailInput,
                    ),
                    pwInput,
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Align(
                  alignment: Alignment.topRight,
                  child: _buildElevatedButton(AppTheme.normalBlue, context)),
              const SizedBox(height: 20),
              Center(
                  child: _hyperLinkBuild(
                      context, "Vous avez déjà un compte ? Se connecter")),
              const SizedBox(height: 30),
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
        ),
      ],
    );
  }

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

  ElevatedButton _buildElevatedButton(Color color, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate() &&
            await LoginAuth.register(
                firstNameInput.getInputText(),
                lastNameInput.getInputText(),
                _currentType!.index,
                emailInput.getInputText(),
                pwInput.getPassword(),
                descriptionInput.getInputText())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
      ),
    );
  }
}
