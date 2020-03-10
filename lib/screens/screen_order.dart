import 'package:flutter/material.dart';
import 'package:merch_2020/const.dart';
import 'package:merch_2020/model_user/model_user.dart';
import 'package:merch_2020/screens/screen_loading.dart';
import 'package:merch_2020/services/service_database.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class ScreenOrder extends StatefulWidget {
  final Store store;

  ScreenOrder({this.store});

  @override
  _ScreenOrderState createState() => _ScreenOrderState();
}

class _ScreenOrderState extends State<ScreenOrder> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ServiceDatabase _serviceDatabase = ServiceDatabase();
  List<String> orders = [];
  bool firstTime = true;
  Decoration _decoration = new BoxDecoration(
    border: new Border(
      top: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.black26,
      ),
      bottom: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.black26,
      ),
    ),
  );

  _showDialog(int index) {
    showDialog<int>(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              accentColor: mainColor,
            ),
            child: NumberPickerDialog.integer(
              minValue: 0,
              maxValue: 20,
              initialIntegerValue: 10,
              titlePadding: EdgeInsets.all(0),
              decoration: _decoration,
              title: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                color: mainColor,
                child: Text(
                  'Number of cards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              confirmWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: mainColor,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              cancelWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: mainColor,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          );
        }).then((val) {
      if (val != null) {
        setState(() {
          orders[index] = val.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<GreetingCard>>.value(
      value: _serviceDatabase.dataCards,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(

          /// BUTTON DRAWER
          leading: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            shape: CircleBorder(),
            padding: EdgeInsets.all(0),
            minWidth: 55,
            height: 55,
          ),
          backgroundColor: mainColor,
          title: Text(widget.store.name),
          elevation: 0,
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                DateTime timeNow = DateTime.now();
                String date =
                    '${timeNow.day}-${timeNow.month}-${timeNow.year}';
                _serviceDatabase.updateDataList(orders, widget.store.id, date);
                Navigator.pop(context);
              },
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minWidth: 55,
              height: 55,
            )
          ],
        ),
        body: StreamBuilder<List<GreetingCard>>(
          stream: _serviceDatabase.dataCards,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ScreenLoading();
            }
            if (firstTime) {
              for (int i = 0; i < snapshot.data.length; i++) {
                orders.add('0');
              }
              firstTime = false;
            }
            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: mainColor,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: orientation == Orientation.portrait
                        ? SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2)
                        : SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _showDialog(index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: mainColor)),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(2),
                                    child: Image.network(
                                      snapshot.data[index].path,
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                color: mainColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 5,
                                      child: Text(
                                        snapshot.data[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        orders[index],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },

              ),
            );
          },
        ),
      ),
    );
  }
}
