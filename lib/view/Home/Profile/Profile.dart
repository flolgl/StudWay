import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studway_project/controller/candidature/Candidature.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/Home/Profile/components/ChangeDescription.dart';
import 'package:studway_project/view/Home/Profile/pages/ExperienceForm.dart';
import 'package:studway_project/view/Home/Profile/pages/FormationForm.dart';
import 'package:studway_project/view/splash.dart';

import '../../AppTheme.dart';
import 'pages/CompetenceForm.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile(this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState(user);
}

class _ProfileState extends State<Profile> {
  File? image;
  final User _user;
  late final int _userFavOffersCount;
  late final int _userCandidatureCount;
  late final int _userAcceptedCandidaturesCount;
  bool _isFetching = true;

  _ProfileState(this._user);

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    if (_user.type == "Entreprise") {
      var userFav = await Offer.fetchAllAnnonceOfEntreprise(_user.id);
      int userCandidatures = 0;
      for (var i = 0; i < userFav.length; i++) {
        var tmp = await Candidature.fetchAllCandidaturesOfOffer(userFav[i]);
        userCandidatures += tmp.length;
      }
      setState(() {
        _userFavOffersCount = userFav.length;
        _userCandidatureCount = userCandidatures;
        _isFetching = false;
      });
    }else{
      var userFav = await _user.fetchCandidatFav();
      var userCandidatures = await _user.fetchCandidature();
      var userAcceptedCandidatures = userCandidatures.where((candidature) => candidature.retenue == 1).toList();
      setState(() {
        _userFavOffersCount = userFav.length;
        _userCandidatureCount = userCandidatures.length;
        _userAcceptedCandidaturesCount = userAcceptedCandidatures.length;
        _isFetching = false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
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
            height: 30,
          ),
          Center(
            child: _buildCircleAvatar(),
          ),
          Center(
              child: buildButton(
            title: 'Choisir depuis la galerie',
            icon: Icons.image_outlined,
            onClicked: () => pickImage(ImageSource.gallery),
          )),
          Center(
              child: buildButton(
            title: 'Prendre une photo',
            icon: Icons.camera_alt_outlined,
            onClicked: () => pickImage(ImageSource.camera),
          )),
          const SizedBox(
            height: 30,
          ),

          // Le container de la partie Options (container avec bg white)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _user.type == "Entreprise" ? _buildEntrepriseStatsInfo() : _buildCandidatStatsInfo(context),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _user.type == "Entreprise" ? _buildEntrepriseOptions() : _buildCandidatOptions(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.exit_to_app_outlined),
                  onPressed: () async{
                    await _user.logout();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Splash()));
                  },
                ),
              ),
            ),
            ),
        ],
      ),
    );

    // return Center(
    //       child: Text(_user.prenom),
    // );
  }


  Widget _buildEntrepriseStatsInfo(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black45),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Nombre d'offres",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _isFetching
                      ? "Chargement..."
                      : _userCandidatureCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black45),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Nombre de candidatures",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _isFetching ? "Chargement..." : _userFavOffersCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children:  [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Prenium",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _isFetching ? "Chargement..." : "Non",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildEntrepriseOptions(){
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangeDescription()));
                },
                child: Container(
                  width: width / 2 - 30,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.description_outlined),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children:[
                                  RichText(
                                  text: const TextSpan(
                                    text: "Changer la\n",
                                    children: [
                                      TextSpan(text: "présentation de l'entreprise"),
                                    ],
                                  ),
                                ),
                                ],

                              ),
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _buildErrorPopUp(context, "Fonctionnalité pas encore disponible");
                },
                child: Container(
                  width: width / 2 - 30,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.euro_outlined),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Premium",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: "Obtenir\n",
                                      children: [
                                        TextSpan(text: "le prenium"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff99d5f3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }

  /// Méthode retournant le form de connexion
  Widget _buildCandidatOptions(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (kIsWeb) {
                    _buildErrorPopUp(context, 'Impossible sur navigateur internet');
                  } else {
                    _user.setUserNewCV();
                  }
                },
                child: Container(
                  width: width / 2 - 30,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Curriculum Vitae",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: "Ajouter\n",
                                      children: [
                                        TextSpan(text: "un CV"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ExperienceForm(_user)));
                },
                child: Container(
                  width: width / 2 - 30,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.business_center_sharp),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Expérience(s) professionnelle(s)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      text: "Ajouter\n",
                                      children: [
                                        TextSpan(text: "une expérience"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff99d5f3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FormationForm(_user)));
                },
                child: Container(
                  width: width / 2 - 30,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.school),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Formation(s)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children:[
                                  RichText(
                                    text: const TextSpan(
                                      text: "Ajouter\n",
                                      children: [
                                        TextSpan(text: "une formation"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff99d5f3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CompetenceForm(_user)));
                },
                child: Container(
                  width: width / 2 - 30,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.handyman),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Text(
                        "Compétences",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                children:[
                                  RichText(
                                    text: const TextSpan(
                                      text: "Ajouter\n",
                                      children: [
                                        TextSpan(text: "une compétence"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }

  void _buildErrorPopUp(BuildContext context, String text) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(text),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne un [CircleAvatar] du user
  Widget _buildCircleAvatar() {
    var shownImage = image != null ? Image.file(image!) as ImageProvider : NetworkImage(_user.profilpic);
    return CircleAvatar(
      radius: 45,
      backgroundImage: shownImage,
    );
  }

  Widget _buildCandidatStatsInfo(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black45),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Nombre de candidatures",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _isFetching
                      ? "Chargement..."
                      : _userCandidatureCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black45),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Nombre de favoris",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _isFetching ? "Chargement..." : _userFavOffersCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children:  [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Nombre de candidatures retenues",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _isFetching ? "Chargement..." : _userAcceptedCandidaturesCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Future pickImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.camera);
      final imageTemporary = File(image!.path);
      setState(() => this.image = imageTemporary);
    } catch (e) {
      _buildErrorPopUp(context, 'Impossible sur navigateur internet');
    }
  }
}

Widget buildButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(260, 35),
            primary: Colors.white,
            onPrimary: Colors.black,
            textStyle: const TextStyle(fontSize: 15)),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
        onPressed: onClicked,
      ),
    );
