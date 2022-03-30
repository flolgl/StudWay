import 'package:flutter/material.dart';
import 'package:studway_project/controller/candidature/Candidature.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:studway_project/controller/user/User.dart';

class CandidatFavList extends StatefulWidget {
  const CandidatFavList({Key? key}) : super(key: key);

  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<CandidatFavList> {
  late List<Offer> _favList;
  late List<Candidature> _candidaturesList;
  bool _isFetched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
        _buildCandidatureListView(),
      ],
    );
  }

  void getData() async {
    var favList = await User.currentUser!.fetchCandidatFav();
    var candidatureList = await User.currentUser!.fetchCandidature();
    setState(() {
      _favList = favList;
      _candidaturesList = candidatureList;
      _isFetched = true;
    });
  }

  void deleteFav(int id) async {
    var deleted = await User.currentUser!.deleteFav(id);
    if (!deleted){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      setState(() {
        _favList.removeWhere((element) => element.id == id);
      });
    }
  }

  void deleteCandidature(int id) async {
    var deleted = await User.currentUser!.deleteCandidature(id);
    if (!deleted){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      setState(() {
        _candidaturesList.removeWhere((element) => element.idCandidature == id);
      });
    }
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
              icon: Icon(Icons.task_outlined),

            ),
          ],
      ),
    );
  }

  Widget _buildFavListView(){
    if (_favList.isEmpty) {
      return const Center(
        child: Text("Aucune offre favorite"),
      );
    }
    return ListView.builder(
      itemCount: _favList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(_favList[index].titre),
            subtitle: Text(_favList[index].description),
            leading: const Icon(Icons.favorite),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteFav(_favList[index].id);
              },
            ),
          ),
        );
      },

    );
  }

    Widget _buildCandidatureListView(){
    if (_candidaturesList.isEmpty) {
      return const Center(
        child: Text("Aucune candidature"),
      );
    }
    return ListView.builder(
      itemCount: _candidaturesList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(_candidaturesList[index].annonce.titre),
            subtitle: Text(_candidaturesList[index].annonce.description),
            leading: const Icon(Icons.task_outlined),
            trailing: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                deleteCandidature(_candidaturesList[index].idCandidature);
              },
            ),
          ),
        );
      },

    );
  }
}