import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/AppTheme.dart';

class AddFormationBody extends StatefulWidget{
  final User _user;
  const AddFormationBody(this._user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddFormationBodyState(_user);

}
// TODO : Vérifier que année = nombre
class AddFormationBodyState extends State<AddFormationBody> {
  final _formKey = GlobalKey<FormState>();
  final User _user;
  DateTime _debutDate = DateTime.now();
  DateTime _finDate = DateTime.now();
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();
  final TextEditingController _nomFormationController = TextEditingController();
  final TextEditingController _nomEtablissementController = TextEditingController();


  AddFormationBodyState(this._user);


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
                        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      child: TextFormField(
                        controller:_nomFormationController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nom de la formation",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.handyman),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Champs vide" : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      child: TextFormField(
                        controller: _nomEtablissementController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Etablissement",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.handyman),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Champs vide" : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Début de la formation",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.handyman),
                        ),
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: _dateDebutController,
                        onTap: () {
                          _selectDate(context, _dateDebutController, _debutDate);
                        },

                        validator: (value) => value == null || value.isEmpty ? "Champs vide" : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Fin de la formation (vide si pas en cours)",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.handyman),
                        ),
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: _dateFinController,
                        onTap: () {
                          _selectDate(context, _dateFinController,_finDate);
                        },

                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                child: const Text(
                  "Ajouter la formation",
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
                    _user.updateUserFormation(<DateTime>[_debutDate, _dateFinController.text.isEmpty ? _debutDate :_finDate], <String>[_nomFormationController.text, _nomEtablissementController.text]);
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


  _selectDate(BuildContext context, TextEditingController textEditingController, DateTime dateToChange) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, textEditingController, dateToChange);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, textEditingController, dateToChange);
    }
  }
  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context, TextEditingController textEditingController, DateTime dateToChange) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateToChange,
      firstDate: DateTime(DateTime.now().year-100),
      lastDate: DateTime(DateTime.now().year+1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _debutDate) {
      setState(() {
        dateToChange = picked;
      });
      textEditingController
        ..text = DateFormat("dd MMMM yyyy").format(dateToChange)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: textEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }
  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context, TextEditingController textEditingController, DateTime dateToChange) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != dateToChange) {
                  setState(() {
                    dateToChange = picked;
                  });
                  textEditingController
                    ..text = DateFormat("dd MMMM yyyy").format(dateToChange)
                    ..selection = TextSelection.fromPosition(TextPosition(
                        offset: textEditingController.text.length,
                        affinity: TextAffinity.upstream));
                }
              },
              initialDateTime: _debutDate,
              minimumYear: DateTime.now().year-100,
              maximumYear: DateTime.now().year,
            ),
          );
        });
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}