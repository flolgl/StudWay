import 'package:flutter/material.dart';
import 'package:studway_project/view/offers/components/OfferContainer.dart';

import '../../../controller/offer/Offer.dart';

class DataSearch extends SearchDelegate<String>{
  final suggestions = [
    "developpeur web",
    "devops",
    "marketing",
    "data scientist",
    "chef de projet",
    "blablabla",
  ];

  var recentSuggestions = [
    "marketing",
    "data scientist",
    "chef de projet",
  ];

  List<int> offerIndexList = [];

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

  @override
  Widget buildResults(BuildContext context) {
    List<Widget> offerListAsWidget = [];
    for(int offerIndex in offerIndexList){
      offerListAsWidget.add(OfferContainer(offerIndex));
    }
    return ListView(
        children: offerListAsWidget,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggestions
        : suggestions.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
        itemBuilder: (context,index) => ListTile(
          onTap: () async {
            offerIndexList = await Offer.fetchOffersByKeyword(suggestionList[index]);
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