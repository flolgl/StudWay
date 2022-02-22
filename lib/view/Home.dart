import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'chat/ChatList.dart';
import 'icons/my_flutter_app_icons.dart';
import '../controller/user/User.dart';
import 'offers/components/DataSearch.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = User.fetchUserInfo();
  }



  int _selectedIndex = 0;
  static const TextStyle _optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: _optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: _optionStyle,
    ),
    Text(
      'Index 2: School',
      style: _optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _buildCenter(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Center _buildCenter() {
    return Center(
      child: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.prenom);
          } else if (snapshot.hasError) {
            return const Text('Impossible de récupérer vos données. Veuillez réessayer plus tard.');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'School',
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

        child:Icon(
          MyFlutterApp.StudWay_logo_white,
          size: 100.0,
        ),
      ),

      actions: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                //icon: const Icon(Icons.message_outlined),
                icon: FutureBuilder<User>(
                  future: futureUser,
                  builder: (context, snapshot) => snapshot.hasData ? Badge(badgeContent: Text(snapshot.data!.nbMsg.toString()), child: const Icon(Icons.message_outlined)) : const Icon(Icons.message_outlined),
                ),
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
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
              ),
            ),
          ]
        ),
      ],
    );
  }

  void _navigateToChatsListScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatList()));
  }
}