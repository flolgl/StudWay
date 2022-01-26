import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String text;

  const TextInput({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : Utiliser le thème pour les couleurs
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade200,
        focusedBorder:const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff4f6d9c), width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),


      ),
      cursorColor: const Color(0xff4f6d9c),


    );
  }
}