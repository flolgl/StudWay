import 'package:flutter/material.dart';

class DoubleConfirmPwInput extends StatelessWidget {
  final String text;
  String _password = "";

  DoubleConfirmPwInput({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String input1 = "";

    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      hintText: text,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: const Icon(Icons.lock_outlined),
    );

    // TODO : Utiliser le thème pour les couleurs
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: TextFormField(
            decoration: decoration.copyWith(hintText: "Mot de passe"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (input) {
              if (input == null || input.isEmpty || input.length < 10) {
                return "Merci de choisir un mot de passe plus difficile";
              }
              if (!validatePw(input)) {
                print(input);
                return "Le mot de passe doit comporter des caractères spéciaux, être de longueur 12 minimum et avoir au moins 1 majuscule";
              }
              input1 = input;
              return null;
            },
            cursorColor: const Color(0xff4f6d9c),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: decoration.copyWith(hintText: "Confirmer mot de passe"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (input) {
              if (input == null || input.isEmpty) {
                return "Merci de choisir un mot de passe";
              }
              if (!validatePw(input)) {
                return "Le mot de passe doit comporter des caractères spéciaux, être de longueur 12 minimum et avoir au moins 1 majuscule";
              }
              if (input1.isEmpty || input1 != input) {
                return "Les deux mots de passe doivent correspondre";
              }
              _password = input;
              return null;
            },
            cursorColor: const Color(0xff4f6d9c),
          ),
        ),
      ],
    );
  }

  String getPassword() {
    return _password;
  }

  bool validatePw(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{12,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
