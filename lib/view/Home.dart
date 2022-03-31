import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studway_project/view/Home/Business/EntrepriseBusinessList.dart';
import 'package:studway_project/view/offers/components/OfferForm.dart';

import '../controller/offer/Offer.dart';
import '../controller/user/User.dart';
import 'Home/Business/CandidatFavList.dart';
import 'Home/Profile/Profile.dart';
import 'chat/ChatList.dart';
import 'icons/my_flutter_app_icons.dart';
import 'offers/components/DataSearch.dart';
import 'offers/components/OfferContainer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
  bool _errorWhileFetching = false;
  bool _fetching = true;
  int _selectedIndex = 0;
  Profile? _profileScreen;
  List<int> _offerIndexList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {

    try {
      var person = await User.fetchUserInfo();
      var offers = await Offer.fetchAllOffersInfo();
      setState(() {
        _offerIndexList = offers;
        _user = person;
        _fetching = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _errorWhileFetching = true;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _buildAppBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBody() {
    if (_fetching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_errorWhileFetching) {
      return const Center(
        child: Text('Error while fetching data'),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return ListView.builder(
          itemCount: _offerIndexList.length,
          itemBuilder: (context, index) {
            return OfferContainer(_offerIndexList[index],);
          },
        );
      case 1:
        return _user.type == "Entreprise" ? const EntrepriseBusinessList() : const CandidatFavList();
      default:
        return _buildProfileScreen();
    }
  }

  Profile _getProfileScreen() {
    return _profileScreen ?? Profile(_user);
  }

  Center _buildProfileScreen() {
    return Center(
      child: _errorWhileFetching
          ? const Text(
              'Impossible de récupérer vos données. Veuillez réessayer plus tard.')
          : _getProfileScreen(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          label: 'Offres',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profil',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
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
      actions: <Widget>[
        Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              //icon: const Icon(Icons.message_outlined),
              icon: _fetching || _errorWhileFetching
                  ? const Icon(Icons.message_outlined)
                  : Badge(
                      badgeContent: Text(_user.nbMsg.toString()),
                      child: const Icon(Icons.message_outlined)),
              tooltip: "",
              onPressed: () {
                _navigateToChatsListScreen(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
              //icon: const Icon(Icons.message_outlined),
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
          ),
        ]),
      ],
    );
  }

  void _navigateToChatsListScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChatList(_user)));
  }
}
