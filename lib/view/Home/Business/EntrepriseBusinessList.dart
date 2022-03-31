import 'package:flutter/material.dart';
import 'package:studway_project/controller/candidature/Candidature.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/User/UserProfile.dart';
import 'package:studway_project/view/offers/components/OfferForm.dart';

class EntrepriseBusinessList extends StatefulWidget {
  const EntrepriseBusinessList({Key? key}) : super(key: key);

  @override
  _EntrepriseBusinessListState createState() => _EntrepriseBusinessListState();
}

class _EntrepriseBusinessListState extends State<EntrepriseBusinessList> {
  late List<Offer> _annoncesList;
  late List<List<Candidature>> _candidaturesList;
  late List<bool> _areNonRefusedCandidaturesShowed;
  late List<bool> _areAllCandidaturesShowed;
  late List<List<User>> _userList;
  bool _isFetched = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if(!_isFetched){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }


    return TabBarView(
      children: [
        _buildFavListView(),
        OfferForm(User.currentUser!),
        //_buildCandidatureListView(),
      ],
    );
  }

  void _getData() async {
    var annoncesList = await Offer.fetchAllAnnonceOfEntreprise(User.currentUser!.id);
    //var candidatureList = await User.currentUser!.fetchCandidature();
    setState(() {
      _annoncesList = annoncesList;
      _candidaturesList = List.filled(annoncesList.length, <Candidature>[]);
      _userList = List.filled(annoncesList.length, <User>[]);
      _areNonRefusedCandidaturesShowed = List.filled(annoncesList.length, false);
      _areAllCandidaturesShowed = List.filled(annoncesList.length, false);
      _isFetched = true;
    });
  }

  // TODO : delete les candidatures
  void _deleteAnnonce(int id) async {
    var deleted = await Offer.deleteUserOffer(id);
    if (!deleted){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      setState(() {
        _annoncesList.removeWhere((element) => element.id == id);
      });
    }
  }


  final snackBar = SnackBar(
    content: const Text('Il est pour le moment impossible de supprimer une annonce'),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  AppBar buildAppBar() {
    return AppBar(
      title: const Center(child: Text("Mes annonces")),
      bottom: const TabBar(
        indicatorColor: Colors.white,
        tabs:[
            Tab(
              icon: Icon(Icons.task_outlined),

            ),
            Tab(
              icon: Icon(Icons.add_outlined),

            ),
          ],
      ),
    );
  }


  Widget _buildFavListView(){
    if (_annoncesList.isEmpty) {
      return const Center(
        child: Text("Aucune offre favorie"),
      );
    }
    return ListView.builder(
      itemCount: _annoncesList.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              ListTile(
                title: Text(_annoncesList[index].titre),
                subtitle: Text(_annoncesList[index].description),
                leading: const Icon(Icons.list),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: "Voir les candidatures non lues ou acceptées",
                      child: IconButton(
                        icon: const Icon(Icons.check_circle_outline_outlined),
                        onPressed: () async {
                          if(_areNonRefusedCandidaturesShowed[index] == true) {
                            setState(() {
                              _areNonRefusedCandidaturesShowed[index] = false;
                            });
                          }

                          var candidatures = await Candidature.fetchCandidaturesNotRefusedOfOffer(_annoncesList[index]);
                          List<User> users = [];
                          for(var candidature in candidatures){
                            users.add(await User.fetchStrictUserInfo(candidature.idCandidat));
                          }
                          setState(() {
                            _userList[index] = users;
                            _candidaturesList[index] = candidatures;
                            _areAllCandidaturesShowed[index] = !_areAllCandidaturesShowed[index];
                          });
                        },
                      ),
                    ),
                    Tooltip(
                      message: "Voir toutes les candidatures",
                      child: IconButton(
                        icon: const Icon(Icons.expand_more_outlined),
                        onPressed: () async {
                          if(_areAllCandidaturesShowed[index] == true) {
                            setState(() {
                              _areAllCandidaturesShowed[index] = false;
                            });
                          }

                          var candidatures = await Candidature.fetchAllCandidaturesOfOffer(_annoncesList[index]);
                          List<User> users = [];
                          for(var candidature in candidatures){
                            users.add(await User.fetchStrictUserInfo(candidature.idCandidat));
                          }
                             //await User.fetchUserInfoByID(userId)
                          setState(() {
                            _userList[index] = users;
                            _candidaturesList[index] = candidatures;
                            _areNonRefusedCandidaturesShowed[index] = !_areNonRefusedCandidaturesShowed[index];
                          });
                        },
                      ),
                    ),
                    Tooltip(
                      message: "Supprimer l'annonce",
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteAnnonce(_annoncesList[index].id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: !_areNonRefusedCandidaturesShowed[index] && !_areAllCandidaturesShowed[index]
                    ? null
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _candidaturesList[index].length,
                          itemBuilder: (context, indice) {
                            return _candidaturesList[index].isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Aucune candidature"),
                                    ),
                                  )
                                : Card(
                                  child: ListTile(
                                    title: Text(_userList[index][indice].prenom + " " + _userList[index][indice].nom),
                                    subtitle: Text(_candidaturesList[index][indice].lettreMotivation),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage("http://localhost:3000/users/photoprofile/${_candidaturesList[index][indice].idCandidat}"),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.person_outlined),
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => UserProfile(_userList[index][indice])));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.done_outlined),
                                          disabledColor: Colors.green,
                                          onPressed: _candidaturesList[index][indice].retenue == 1 ? null : () async{

                                            if (await _candidaturesList[index][indice].setRetenueState(1)){
                                              setState(() {
                                                _candidaturesList[index][indice].retenue = 1;
                                              });
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          disabledColor: Colors.red,
                                          onPressed: _candidaturesList[index][indice].retenue == 0 ? null : () async{

                                            if (await _candidaturesList[index][indice].setRetenueState(0)){
                                              setState(() {
                                                // remove candidature
                                                _candidaturesList[index].removeAt(indice);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                          },
                        ),
                    ),
              )
            ],
          ),
        );
      },

    );
  }
}