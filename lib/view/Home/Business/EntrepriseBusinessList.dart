import 'package:flutter/material.dart';
import 'package:studway_project/controller/candidature/Candidature.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/offers/components/OfferForm.dart';

class EntrepriseBusinessList extends StatefulWidget {
  const EntrepriseBusinessList({Key? key}) : super(key: key);

  @override
  _EntrepriseBusinessListState createState() => _EntrepriseBusinessListState();
}

class _EntrepriseBusinessListState extends State<EntrepriseBusinessList> {
  late List<Offer> _annoncesList;
  late List<List<Candidature>> _candidaturesList;
  late List<bool> _areCandidaturesShowed;
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
      _areCandidaturesShowed = List.filled(annoncesList.length, false);
      _isFetched = true;
    });
  }

  // TODO : delete les candidatures
  void deleteFav(int id) async {
    // var deleted = await Candidature.deleteCandidature(id);
    // if (!deleted){
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }else{
    //   setState(() {
    //     _annoncesList.removeWhere((element) => element.id == id);
    //   });
    // }
  }


  final snackBar = SnackBar(
    content: const Text('Erreur lors de la suppression'),
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
              icon: Icon(Icons.favorite),

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
              GestureDetector(
                onTap: () async {
                  var candidatures = await Candidature.fetchCandidaturesOfOffer(_annoncesList[index]);
                  setState(() {
                    if (candidatures.isNotEmpty){
                      _candidaturesList[index] = candidatures;
                    }
                    _areCandidaturesShowed[index] = !_areCandidaturesShowed[index];
                  });
                  //Navigator.pushNamed(context, '/annonce', arguments: _annoncesList[index]);
                },
                child: ListTile(
                  title: Text(_annoncesList[index].titre),
                  subtitle: Text(_annoncesList[index].description),
                  leading: const Icon(Icons.list),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteFav(_annoncesList[index].id);
                    },
                  ),
                ),
              ),
              Container(
                child: !_areCandidaturesShowed[index]
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Afficher les candidatures"),
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _candidaturesList[index].length,
                          itemBuilder: (context, indice) {
                            return _candidaturesList[index].length == 0
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Aucune candidature"),
                                    ),
                                  )
                                : Card(
                                  child: ListTile(
                                    title: Text(_candidaturesList[index][indice].idCandidat.toString()),
                                    subtitle: Text(_candidaturesList[index][indice].lettreMotivation),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage("http://localhost:3000/users/photoprofile/${_candidaturesList[index][indice].idCandidat}"),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        deleteFav(_candidaturesList[index][indice].idCandidat);
                                      },
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