import 'package:flutter/material.dart';
import 'chat/ChatList.dart';
import 'icons/my_flutter_app_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
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
      body: buildCenter(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Center buildCenter() {
    return Center(
      child: _widgetOptions.elementAt(_selectedIndex),
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
      selectedItemColor: Colors.blue,
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