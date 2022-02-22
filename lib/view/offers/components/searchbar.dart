import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        pinned: _pinned,
        snap: _snap,
        floating: _floating,
        expandedHeight: 160.0,
        flexibleSpace: const FlexibleSpaceBar(
          background: Image(image: AssetImage('C:\\Users\\ayoub\\OneDrive\\Bureau\\StudWay\\assets\\images\\studway_blanc.png')),
        ),
    );
  }
}
