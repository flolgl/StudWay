import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/Home/Profile/pages/ExperienceForm.dart';
import 'package:studway_project/view/Home/Profile/pages/FormationForm.dart';

import '../../AppTheme.dart';
import 'pages/CompetenceForm.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class Profile extends StatelessWidget {
  final User _user;

  const Profile(this._user, {Key? key}) : super(key: key);

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
          const SizedBox(height: 30,),
          Center(
            child: _buildCircleAvatar(),
          ),
          const SizedBox(height: 30,),

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
                    _buildStatsInfo(context),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _buildOptionsBody(context),
                    ),
                  ],
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


  /// Méthode retournant le form de connexion
  Widget _buildOptionsBody(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){
                  if (kIsWeb) {
                    _buildErrorPopUp(context);
                  } else {
                    _user.setUserNewCV();
                  }
                },
                child: Container(
                  width: width/2-30,
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
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            RichText(
                              text: const TextSpan(
                                  text:"Ajouter\n",
                                  children: [
                                    TextSpan(text:"un CV"),
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
            const SizedBox(height: 15,),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExperienceForm(_user)));},
                child: Container(
                  width: width/2-30,
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
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            RichText(
                              text: const TextSpan(
                                text:"Ajouter\n",
                                children: [
                                  TextSpan(text:"une expérience"),
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
            const SizedBox(height: 15,),



          ],
        ),
        Column(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormationForm(_user)));},
                child : Container(
                  width: width/2-30,
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
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            RichText(
                              text: const TextSpan(
                                text:"Ajouter\n",
                                children: [
                                  TextSpan(text:"une formation"),
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
            const SizedBox(height: 15,),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompetenceForm(_user)));},
                child: Container(
                  width: width/2-30,
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
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            RichText(
                              text: const TextSpan(
                                text:"Ajouter\n",
                                children: [
                                  TextSpan(text:"une compétence"),
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
            const SizedBox(height: 15,),

          ],
        ),
      ],
    );
  }

  void _buildErrorPopUp(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Impossible sur navigateur internet'),
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

  // TODO : vraiment mettre la photo de profile
  /// Retournant un [CircleAvatar] du user
  Widget _buildCircleAvatar() {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      width: 150,
      height: 150,
    );
  }

  Widget _buildStatsInfo(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color:Colors.black45),
                ),
            ),
            child: Column(
                children: const [
                  SizedBox(height: 10,),
                  Text("Applied", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45, fontSize: 14),),
                  SizedBox(height: 10,),
                  Text("23", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                ],
            ),
          ),

        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color:Colors.black45),
                ),
            ),
            child: Column(
                children: const [
                  SizedBox(height: 10,),
                  Text("Applied", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45, fontSize: 14),),
                  SizedBox(height: 10,),
                  Text("23", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                ],
            ),
          ),

        ),
        Expanded(
          child: Container(
            child: Column(
                children: const [
                  SizedBox(height: 10,),
                  Text("Applied", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45, fontSize: 14),),
                  SizedBox(height: 10,),
                  Text("23", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                ],
            ),
          ),

        ),

      ],
    );
  }

  void _navigateToProfileForm(BuildContext context) {
    ;
  }

}

//
// Container(
// child: Text("Ajouter une formation"),
// ),
// Container(
// child: Text("Ajouter un expérience professionnelle"),
// ),
// Container(
// child: Text("Ajouter une compétence"),
// ),