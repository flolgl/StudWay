import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studway_project/view/AppTheme.dart';

import '../../../controller/user/User.dart';

class AddOfferBody extends StatefulWidget {
  final User _user;

  const AddOfferBody(this._user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddOfferBodyState(_user);
}

class AddOfferBodyState extends State<AddOfferBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final User _user;
  String formResponse = "";

  AddOfferBodyState(this._user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(39, 58, 105, 3),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Titre de l'annonce",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.title_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Champs vide" : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Description de l'annonce",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Champs vide" : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Site de travail",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Champs vide" : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: const Text(
                "Ajouter l'annonce",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: AppTheme.normalBlue,
                fixedSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _user.createNewOffer(_titleController.text,
                      _locationController.text, _descriptionController.text);
                  _titleController.clear();
                  _locationController.clear();
                  _descriptionController.clear();
                  setState(() {
                    formResponse = "Annonce publiée avec succès";
                  });
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: formResponse,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
