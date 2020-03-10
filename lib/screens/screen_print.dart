import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merch_2020/const.dart';
import 'package:merch_2020/model_user/model_user.dart';
import 'package:merch_2020/services/service_database.dart';
import 'package:provider/provider.dart';
import 'screen_loading.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

class ScreenPrint extends StatefulWidget {
  final Store store;

  ScreenPrint({this.store});

  @override
  _ScreenPrintState createState() => _ScreenPrintState();
}

class _ScreenPrintState extends State<ScreenPrint> {
  String invoiceNumber;
  ServiceDatabase _serviceDatabase = ServiceDatabase();
  int volume = 0, price = 200, total = 0;
  GlobalKey _screenKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.store.cards.forEach((val) {
      volume = int.parse(val) + volume;
    });
  }

  void screenShot() async {
    RenderRepaintBoundary boundary =
        _screenKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    var filePath = await ImagePickerSaver.saveFile(
        fileData: byteData.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PersonalData>>.value(
      value: _serviceDatabase.personalData,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Faktura'),
          elevation: 0,
          backgroundColor: mainColor,
          actions: <Widget>[
            /// Settings Button

            MaterialButton(
              onPressed: () {},
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minWidth: 55,
              height: 55,
            ),
            MaterialButton(
              onPressed: screenShot,
              child: Icon(
                Icons.mail,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              minWidth: 55,
              height: 55,
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _serviceDatabase.personalData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ScreenLoading();
              }
              return SafeArea(
                child: RepaintBoundary(
                  key: _screenKey,
                  child: Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        /// Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Faktura: $invoiceNumber',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Text('Datum: ${widget.store.time}')
                          ],
                        ),
                        Container(
                          height: 2,
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),

                        /// Body Information
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Od:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    snapshot.data[0].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text('Adresa:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(snapshot.data[0].address),
                                  Text('Delatnost:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(snapshot.data[0].serviceType),
                                  Text('PIB:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(snapshot.data[0].pib),
                                  Text(
                                    'Broj racuna:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(snapshot.data[0].accountNumber),
                                  Text(
                                    'email:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(snapshot.data[0].email),
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('Komitent:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 5),
                                  Text(
                                    widget.store.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text('Adresa:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(widget.store.address),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 2,
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text('VRSTA USLUGE'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 70,
                              child: Text('JEDINICA'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text('KOLICINA'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text('CENA'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text('TOTAL'),
                            )
                          ],
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text('Administrativne usluge'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text('Komad'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text(volume.toString()),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text('200'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text('${volume * price}'),
                            ),
                          ],
                        ),
                        Container(
                          height: 2,
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'UKUPNO (RSD)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            Text(
                              '${(volume * price).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            )
                          ],
                        ),
                        Spacer(),
                        Text(
                          'Komentar:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(snapshot.data[0].commentOne),
                        Container(height: 30),
                        Text(
                          'Napomena o poreskom resenju:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(snapshot.data[0].commentTwo),
                        Spacer(),
                        Container(
                          height: 2,
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Text(snapshot.data[0].name, textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
