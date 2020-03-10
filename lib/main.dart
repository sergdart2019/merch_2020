import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merch_2020/const.dart';
import 'package:merch_2020/screens/screen_home.dart';
import 'package:merch_2020/screens/screen_login.dart';
import 'package:merch_2020/services/service_authenticate.dart';
import 'package:provider/provider.dart';

import 'model_user/model_user.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: mainColor));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: ServiceAuthenticate().user)
      ],
      child: MaterialApp(
        title: 'Merch 2020',
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return SafeArea(child: ScreenLogin());
    } else {
      return ScreenHome();
    }
  }
}

// 19 https://www.youtube.com/watch?v=ggYTQn4WVuw&list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC&index=19
