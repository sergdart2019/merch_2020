import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merch_2020/model_user/model_user.dart';
import 'package:merch_2020/screens/screen_loading.dart';
import 'package:merch_2020/services/service_authenticate.dart';
import 'package:merch_2020/services/service_database.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import 'screen_image.dart';
import 'screen_order.dart';
import 'screen_print.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final ServiceAuthenticate _serviceAuthenticate = ServiceAuthenticate();
  final ServiceDatabase _serviceDatabase = ServiceDatabase();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name, address, error = '';
  String personalDataName,
      personalDataAddress,
      personalDataServiceType,
      personalDataPib,
      personalDataAccountNumber,
      personalDataEmail,
      personalDataCommentOne,
      personalDataCommentTwo;
  bool loading = false;

  List<Map<String, dynamic>> dataMapSorted;
  List<Store> dataSorted;
  final _formKey = GlobalKey<FormState>();
  bool showSearchBar = false;

  List<Store> sortData(List list) {
    list.sort((e1, e2) => e1.name.compareTo(e2.name));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Store>>.value(
      value: _serviceDatabase.data, // List of Stores Stream
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,

          /// BUTTON DRAWER
          leading: MaterialButton(
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            shape: CircleBorder(),
            padding: EdgeInsets.all(0),
            minWidth: 55,
            height: 55,
          ),

          /// SEARCH BAR TOGGLE
          title: showSearchBar
              ? TextField(
                  decoration:
                      _decorationTFF('Search...', Icons.business, mainColor),
                  cursorColor: mainColor,
                  style: TextStyle(color: mainColor, fontSize: 16),
                  onChanged: (text) {
                    setState(() {
//                      dataMapSortedDisplay = dataMapSorted.where((val) {
//                        var noteTitle = val['name'].toLowerCase();
//                        return noteTitle.contains(text);
//                      }).toList();
                    });
                  },
                )
              : Text('Merch 2020', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            /// BUTTON SEARCH
            MaterialButton(
              onPressed: () {
                setState(() {
                  showSearchBar = !showSearchBar;
//                  if (showSearchBar == false)
//                   dataMapSortedDisplay = dataMapSorted;
                });
              },
              child: showSearchBar
                  ? Icon(Icons.close, color: Colors.white)
                  : Icon(Icons.search, color: Colors.white),
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minWidth: 55,
              height: 55,
            ),

            /// BUTTON ADD STORE
            MaterialButton(
              onPressed: () => addStoreDialog(user),
              child: Icon(
                Icons.playlist_add,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minWidth: 55,
              height: 55,
            )
          ],
        ),

        /// DRAWER
        drawer: SafeArea(child: _drawer(user)),

        /// LISTVIEW
        body: StreamBuilder<List<Store>>(
          stream: _serviceDatabase.data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ScreenLoading();
            }
            return GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: mainColor,
              child: Container(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1,
                      color: mainColor,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                    );
                  },
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    dataSorted = sortData(snapshot.data);
                    return Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: mainColor,
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.flag,
                              color: _getDateColor(snapshot.data[index].time),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                dataSorted[index].name,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: mainColor, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        dataSorted[index].address,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: mainColor.withOpacity(0.6),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          snapshot.data[index].user,
                                          style: TextStyle(
                                              fontSize: 16, color: mainColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot.data[index].time,
                                          style: TextStyle(
                                              fontSize: 16, color: mainColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    /// Button Edit
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScreenOrder(
                                                      store: dataSorted[index],
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      elevation: 0,
                                      shape: CircleBorder(),
                                      color: mainColor,
                                      padding: EdgeInsets.all(0),
                                      minWidth: 55,
                                      height: 55,
                                    ),

                                    /// Button print
                                    MaterialButton(
                                      onPressed: () {
                                        print('${dataSorted[index].name}');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScreenPrint(
                                                      store: dataSorted[index],
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.print,
                                        color: Colors.white,
                                      ),
                                      color: mainColor,
                                      elevation: 0,
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(0),
                                      minWidth: 55,
                                      height: 55,
                                    ),

                                    /// Button delete
                                    MaterialButton(
                                      onPressed: () {
                                        removeStoreDialog(
                                          dataSorted[index].name,
                                          dataSorted[index].id,
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      color: mainColor,
                                      elevation: 0,
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(0),
                                      minWidth: 55,
                                      height: 55,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getDateColor(String date) {
    DateTime timeNow = DateTime.now();
    String dateNow = '${timeNow.day}-${timeNow.month}-${timeNow.year}';
    if (date == dateNow) {
      return Colors.green;
    } else
      return Colors.red;
  }

  /// Drawer
  Drawer _drawer(User user) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 15, bottom: 15),
              height: 110,
              color: mainColor,
              child: Text(
                '${user.email}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            _drawerButton(Icons.image, 'Upload Image', () async {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScreenImage()));
            }),
            _spacerLine(),
            _drawerButton(Icons.person, 'Personal Data', () async {
              Navigator.pop(context);
              addPersonalData();
            }),
            Flexible(
              child: Container(),
            ),
            _spacerLine(),
            _drawerButton(Icons.exit_to_app, 'Log Out', () async {
              Navigator.pop(context); // to avoid errors, close Drawer...
              await _serviceAuthenticate.signOut();
            }),
          ],
        ),
      ),
    );
  }

  Widget _spacerLine() {
    return Container(
      height: 1,
      color: mainColor,
      margin: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  Widget _drawerButton(IconData icon, String title, Function onPress) {
    return Container(
      height: 52,
      child: FlatButton.icon(
        onPressed: onPress,
        icon: Icon(
          icon,
          color: mainColor,
        ),
        label: Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: TextStyle(color: mainColor, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  /// Add Personal Data Dialog
  void addPersonalData() {
    showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Submit',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    color: mainColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        DateTime timeNow = DateTime.now();
                        String date =
                            '${timeNow.day}-${timeNow.month}-${timeNow.year}';
                        dynamic result =
                            await _serviceDatabase.createPersonalData(
                          personalDataName,
                          personalDataAddress,
                          personalDataServiceType,
                          personalDataPib,
                          personalDataAccountNumber,
                          personalDataEmail,
                          personalDataCommentOne,
                          personalDataCommentTwo,
                        );
                        Navigator.pop(context);
                        if (result == null) {
                          setState(() {
                            error = 'Erorr';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      color: mainColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Title
                    Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15),
                      color: mainColor,
                      child: Text(
                        'Add Personal Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Personal Data Name TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                top: 30, left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              onChanged: (val) => personalDataName = val,
                              style: TextStyle(color: mainColor),
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide name, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'name', Icons.business, mainColor),
                            ),
                          ),
                          // Personal Data Address TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => personalDataAddress = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide address, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'address', Icons.location_city, mainColor),
                            ),
                          ),
                          // Personal Data Service Type TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => personalDataServiceType = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide value, or cancel'
                                  : null,
                              decoration: _decorationTFF('service type',
                                  Icons.local_activity, mainColor),
                            ),
                          ),
                          // Personal Data PIB TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => personalDataPib = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide value, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'pib', Icons.confirmation_number, mainColor),
                            ),
                          ),
                          // Personal Data Account Number TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) =>
                                  personalDataAccountNumber = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide value, or cancel'
                                  : null,
                              decoration: _decorationTFF('account number',
                                  Icons.credit_card, mainColor),
                            ),
                          ),
                          // Personal Data Email TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => personalDataEmail = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide value, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'email', Icons.email, mainColor),
                            ),
                          ),
                          // Personal Data Comment One TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => personalDataCommentOne = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide value, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'comment one', Icons.comment, mainColor),
                            ),
                          ),
                          // Personal Data Comment Two TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => personalDataCommentTwo = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide value, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'comment two', Icons.comment, mainColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  /// Remove Store Dialog
  void removeStoreDialog(String name, String documentId) {
    showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Remove',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    color: mainColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    onPressed: () async {
                      Navigator.pop(context);
                      _serviceDatabase.deleteStore(documentId);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      color: mainColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15),
                      color: mainColor,
                      child: Text(
                        'Remove $name?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  /// Add Store Dialog
  void addStoreDialog(User user) {
    showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Submit',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    color: mainColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        DateTime timeNow = DateTime.now();
                        String date =
                            '${timeNow.day}-${timeNow.month}-${timeNow.year}';
                        dynamic result = await _serviceDatabase.createStore(
                          name,
                          address,
                          [],
                          user.email,
                          date,
                        );
                        Navigator.pop(context);
                        if (result == null) {
                          setState(() {
                            error = 'Erorr';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      color: mainColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15),
                      color: mainColor,
                      child: Text(
                        'Add Store',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Email TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                top: 40, left: 12, right: 12, bottom: 30),
                            child: TextFormField(
                              onChanged: (val) => name = val,
                              style: TextStyle(color: mainColor),
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide name, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'name', Icons.business, mainColor),
                            ),
                          ),
                          // Password TFF
                          Container(
                            width: 290.0,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 20),
                            child: TextFormField(
                              style: TextStyle(color: mainColor),
                              onChanged: (val) => address = val,
                              cursorColor: mainColor,
                              validator: (val) => (val.isEmpty)
                                  ? 'Please provide address, or cancel'
                                  : null,
                              decoration: _decorationTFF(
                                  'address', Icons.location_city, mainColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  /// TextFormField Decoration
  InputDecoration _decorationTFF(
    String hintText,
    IconData icon,
    Color color,
  ) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2.0),
      ),
      prefixIcon: Icon(
        icon,
        color: color,
      ),
      fillColor: Colors.white,
      filled: true,
      hintText: hintText,
      border: InputBorder.none,
      hintStyle: TextStyle(color: color.withOpacity(0.5)),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
