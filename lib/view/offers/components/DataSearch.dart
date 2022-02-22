import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String>{
  final suggestions = [
    "developpeur web",
    "devops",
    "marketing",
    "data scientist",
    "chef de projet",
    "blablabla",
  ];

  final recentSuggestions = [
    "marketing",
    "data scientist",
    "chef de projet",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () {
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
    onPressed: () {
          close(context, "");
    });
  }

  //TODO : FETCH DANS LA BD DES OFFRES CORRESPONDANT A LA RECHERCHE
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      color: Colors.red,
      child: Center(
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggestions
        : suggestions.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
        itemBuilder: (context,index) => ListTile(
          onTap: () {
            showResults(context);
          },
          leading: const Icon(Icons.manage_search),
          title: RichText(
            text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text:suggestionList[index].substring(query.length),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      itemCount: suggestionList.length,
    );
  }

}