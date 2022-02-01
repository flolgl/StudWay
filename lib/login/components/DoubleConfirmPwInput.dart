
import 'package:flutter/material.dart';

class DoubleConfirmPwInput extends StatelessWidget {
  final String text;

  const DoubleConfirmPwInput({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String input1 = "";


    InputDecoration decoration = InputDecoration(
      border: const OutlineInputBorder(),
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade200,
      focusedBorder:const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff4f6d9c), width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.0),
      ),

    );


    // TODO : Utiliser le thème pour les couleurs
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: TextFormField(
            decoration: decoration.copyWith(hintText: "Mot de passe"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator:(input){
              if(input == null || input.isEmpty || input.length < 10)
                return "Merci de choisir un mot de passe plus difficile";
              if (!validatePw(input))
                return "Le mot de passe doit comporter des caractères spéciaux, être de longueur 12 minimum et avoir au moins 1 majuscule";
              input1 = input;
              return null;

            },
            cursorColor: const Color(0xff4f6d9c),


          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: TextFormField(
            decoration: decoration.copyWith(hintText: "Confirmer mot de passe"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator:(input){
              if(input == null || input.isEmpty)
                return "Merci de choisir un mot de passe";
              if (!validatePw(input))
                return "Le mot de passe doit comporter des caractères spéciaux, être de longueur 12 minimum et avoir au moins 1 majuscule";
              if(input1 == null || input1.isEmpty || input1 != input)
                return "Les deux mots de passe doivent correspondre";
              return null;

            },
            cursorColor: const Color(0xff4f6d9c),


          ),
        ),
      ],
    );
  }

  bool validatePw(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{12,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}