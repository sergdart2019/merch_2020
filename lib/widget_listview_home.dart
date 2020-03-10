import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merch_2020/const.dart';
import 'package:merch_2020/counter_example.dart';
import 'package:merch_2020/screens/screen_loading.dart';
import 'package:merch_2020/services/service_database.dart';
import 'package:provider/provider.dart';

import 'model_user/model_user.dart';

class ListViewHome extends StatefulWidget {
  @override
  _ListViewHomeState createState() => _ListViewHomeState();
}

class _ListViewHomeState extends State<ListViewHome> {
  ServiceDatabase _serviceDatabase = ServiceDatabase();

  @override
  Widget build(BuildContext context) {
    final stores = Provider.of<List<Store>>(context);
    return StreamBuilder<List<Store>>(
      stream: _serviceDatabase.data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ScreenLoading();
        } else
          return GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: mainColor,
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Card(
                    child: ListTile(
                        title: Text(
                          stores[index].name,
                          style: TextStyle(color: mainColor, fontSize: 18),
                        ),
                        subtitle: Text(
                          stores[index].address,
                          style: TextStyle(
                            color: mainColor.withOpacity(0.6),
                            fontSize: 15,
                          ),
                        ),
                        trailing: Column(
                          children: <Widget>[
                            getTime(stores[index].time),
                            Text(
                              stores[index].user,
                              style: TextStyle(color: mainColor),
                            )
                          ],
                        )),
                  ),
                );
              },
            ),
          );
      },
    );
  }

  Container getTime(String time) {
    List<String> timeList = time.split('-');
    String day = timeList[0];
    String month = timeList[1];
    String year = timeList[2];
    return Container(
        height: 30,
        width: 80,
        alignment: Alignment.center,
        child: Text(
          '$day-$month-$year',
          style: TextStyle(color: mainColor, fontSize: 15,fontWeight: FontWeight.w600),
        ));
  }
}

/*
Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [mainColor, mainColor.withOpacity(0.5)],
                        stops: [0.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: mainColor,
                    child: ListView.builder(
                      itemCount: dataMapSortedDisplay.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print(dataMapSortedDisplay[index]['name']);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => null()));
                          },
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Text(
                                    '${dataMapSortedDisplay[index]['name']}',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    '${dataMapSorted[index]['adresa']}',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(4),
                                          bottomLeft: Radius.circular(4))),
                                  child: Text(
                                    '18-Feb-2020',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
 */
