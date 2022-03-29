import 'package:flutter/material.dart';
import 'package:studway_project/controller/offer/Offer.dart';
import 'package:studway_project/controller/user/User.dart';

class CandidatFavList extends StatefulWidget {
  const CandidatFavList({Key? key}) : super(key: key);

  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<CandidatFavList> {
  late final List<Offer> _favList;
  bool _isFetched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavList();
  }

  @override
  Widget build(BuildContext context) {
    if(!_isFetched){
      print("ici");
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if(_favList.isEmpty){
      return const Center(
        child: Text("Aucune offre favorie"),
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

  void getFavList() async {
    var favList = await User.currentUser!.fetchCandidatFav();

    setState(() {
      _favList = favList;
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

  final snackBar = SnackBar(
    content: const Text('Erreur lors de la suppression'),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}