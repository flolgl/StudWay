import 'package:flutter/material.dart';
import 'package:studway_project/Home.dart';

class PageCreationFactory {


  static Widget createPage(int page){
    switch (page){
      default:
        return const HomePage();
    }

  }
}