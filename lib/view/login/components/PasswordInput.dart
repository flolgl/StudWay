import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final String text;
  final bool isRegister;
  String _inputText = '';

  PasswordInput({Key? key, required this.text, required this.isRegister}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : Utiliser le thème pour les couleurs
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock_outlined),
      ),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      validator: (input) {
        if (input == null || input.isEmpty || input.length < 10) {
          return isRegister ? "Merci de choisir un mot de passe plus difficile" : "Merci de saisir votre mot de passe";
        }
        _inputText = input;
        return null;
      },
      cursorColor: const Color(0xff4f6d9c),
    );
  }

  String getInputText() {
    return _inputText;
  }
}
