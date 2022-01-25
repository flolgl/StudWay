import 'package:flutter/material.dart';
import 'package:studway_project/navBar.dart';

class PageCreationFactory {


  static Widget createPage(int page){
    switch (page){
      default:
        return const MyStatefulWidget();
    }

  }
}