import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/AppTheme.dart';
import 'package:studway_project/view/icons/my_flutter_app_icons.dart';

class ChangeDescription extends StatefulWidget {


  const ChangeDescription({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChangeDescriptionState();
}

class ChangeDescriptionState extends State<ChangeDescription> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _coverLetterController = TextEditingController();
  String warningMessage = "";
  Color warningMessageColor = Colors.black;


  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var description = User.currentUser!.description;
    setState(() {
      _coverLetterController.text = description != null && description != "" ? description : "";
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _buildAppBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Icon(
          MyFlutterApp.StudWay_logo_white,
          size: 100.0,
        ),
      ),
    );
  }

  Widget _buildAppBody() {
    return SingleChildScrollView(
      reverse: true,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 15,
                bottom: 15,
                right: 15,
              ),
              child: RichText(
                text: const TextSpan(
                  text: "Description",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: double.infinity,
                minHeight: 300,
                minWidth: 300,
                maxWidth: 370,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: -7,
                    blurRadius: 15,
                    offset: const Offset(0, 10), // changes position of shadow
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _coverLetterController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Votre description",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Champs vide" : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(280, 35),
                    primary: AppTheme.normalBlue,
                    onPrimary: Colors.white,
                    textStyle: const TextStyle(fontSize: 15)),
                child: Row(
                  children: const [
                    Icon(Icons.send, size: 28),
                    SizedBox(width: 16),
                    Text("Changer la description"),
                  ],
                ),
                onPressed: () async {
                  User.currentUser!.updateUserDescription(_coverLetterController.text);
                },
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: warningMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: warningMessageColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
