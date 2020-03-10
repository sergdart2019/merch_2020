import 'package:flutter/material.dart';

import '../const.dart';

class DataSearch extends SearchDelegate<String> {
  List<Map<String, String>> dataMap = [
    {'name': 'Beograd', 'adresa': 'Klare Cetkin'},
    {'name': 'Atina', 'adresa': 'Klare Cetkin 3'},
    {'name': 'Krusevac', 'adresa': 'Klare Cetkin2'},
    {'name': 'Ada', 'adresa': 'Klare Cetkin'},
    {'name': 'Novi Sad', 'adresa': 'Klare Cetkin2'},
    {'name': 'Apatin', 'adresa': 'Klare Cetkin2'},
  ];

  String name = '', adresa = '';

  /// CLOSE ARROW
  @override
  List<Widget> buildActions(BuildContext context) {
    dataMap.sort((e1, e2) => e1['name'].compareTo(e2['name']));
    // Actions on search bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  /// BACK ARROW
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: Colors.teal,
      child: Card(
        child: Text('$name $adresa', style: TextStyle(color: Colors.blue),),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = dataMap
        .where((val) => val['name'].toLowerCase().startsWith(query))
        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            name = suggestionList[index]['name'];
            adresa = suggestionList[index]['adresa'];
            showResults(context);
          },
          leading: Icon(
            Icons.business,
            color: mainColor,
          ),
          title: RichText(
            text: TextSpan(
              text: suggestionList[index]['name'].substring(0, query.length),
              style: TextStyle(
                color: mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: suggestionList[index]['name'].substring(query.length),
                  style: TextStyle(
                      color: mainColor.withOpacity(0.6), fontSize: 16),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}