import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studway_project/controller/experience/Experience.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/AppTheme.dart';

class UserProfile extends StatefulWidget {
  late final User _user;

  UserProfile(this._user, {Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState(_user);
}

class _UserProfileState extends State<UserProfile> {
  late final User user;
  late final List<Experience> _exp;
  bool isFetching = true;

  _UserProfileState(this.user);

  @override
  void initState() {
    print(user.id);
    // TODO: implement initState
    super.initState();
    _getData();
  }

  void _getData() async {
    var experience = await Experience.getExperiencesFromUserId(user.id);
    setState(() {
      _exp = experience;
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var gradientDecoration = BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        AppTheme.darkerBlue,
        AppTheme.normalBlue,
      ]),
    );
    // build a user profile page with the user's name, profile picture, experiences and skills
    return Scaffold(
      appBar: AppBar(
        title: Text(user.prenom + " " + user.nom),
      ),
      body: isFetching
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: gradientDecoration,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      _buildCircleAvatar(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${user.prenom} ${user.nom}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Formations"),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _exp.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (_exp[index].type != "formation") {
                                    return Container();
                                  }
                                  return Card(
                                    child: ListTile(
                                      leading: const Icon(Icons.school),
                                      title: Text(
                                          '${_exp[index].poste} à ${_exp[index].societe}'),
                                      subtitle: const Text('Formation'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Expérience(s) professionnelle(s)"),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _exp.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (_exp[index].type != "experiencePro") {
                                    return Container();
                                  }
                                  return Card(
                                    child: ListTile(
                                      leading: const Icon(Icons.work),
                                      title: Text(
                                          '${_exp[index].poste} à ${_exp[index].societe}'),
                                      subtitle: const Text('Expérience professionnelle'),
                                      trailing: Text(
                                        '${DateFormat("dd MMMM yyyy").format(_exp[index].dateDebut)} - ${DateFormat("dd MMMM yyyy").format(_exp[index].dateFin)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildCircleAvatar() {
    return CircleAvatar(
      radius: 50.0,
      backgroundImage:
          NetworkImage("http://localhost:3000/users/photoprofile/${user.id}"),
    );
  }
}
