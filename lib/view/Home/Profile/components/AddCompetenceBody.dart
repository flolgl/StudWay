import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/AppTheme.dart';

class AddCompetenceBody extends StatefulWidget{
  final User _user;
  const AddCompetenceBody(this._user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddCompetenceBodyState(_user);

}

class AddCompetenceBodyState extends State<AddCompetenceBody> {
  final _formKey = GlobalKey<FormState>();
  final User _user;
  final TextEditingController _competenceController = TextEditingController();

  AddCompetenceBodyState(this._user);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
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
                child: TextFormField(
                  controller: _competenceController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nom de la compétence",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.handyman),
                  ),
                  validator: (value) => value == null || value.isEmpty ? "Champs vide" : null,
                ),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                child: const Text(
                  "Ajouter la compétence",
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
                    _user.updateUserCompetence(_competenceController.text);
                    Navigator.pop(context);
                  }
                },

              ),
            ],
          ),
        ),
      ),
    );
  }

}