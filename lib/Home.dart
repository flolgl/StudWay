import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:studway_project/user/User.dart';
import 'chat/ChatList.dart';
import 'icons/my_flutter_app_icons.dart';
import 'package:http/http.dart' as http;

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
    futureUser = fetchUserInfo();
  }



  Future<User> fetchUserInfo() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/users/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
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
            return Text('${snapshot.error}');
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
        IconButton(
          icon: const Icon(Icons.message_outlined),
          tooltip: "",
          onPressed: () {
            _navigateToChatsListScreen(context);

          },
        ),
      ],
    );
  }

  void _navigateToChatsListScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatList()));
  }
}