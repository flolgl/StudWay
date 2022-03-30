import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String text;
  String _inputText = '';
  bool emailValidator = false;

  TextInput({Key? key, required this.text, required this.emailValidator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : Utiliser le thème pour les couleurs
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.person_outlined),
      ),
      validator: (input) {
        if(emailValidator) {
          if (input == null || input.isEmpty || !EmailValidator.validate(input))
            return "Merci de rentrer une email valide";
        }
        if(input != null) {
          _inputText = input;
        }
        return null;
      },
      cursorColor: const Color(0xff4f6d9c),
    );
  }

  String getInputText() {
    return _inputText;
  }
}
