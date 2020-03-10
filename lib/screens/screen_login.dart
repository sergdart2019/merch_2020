import 'package:flutter/material.dart';
import 'package:merch_2020/screens/screen_loading.dart';
import 'package:merch_2020/services/service_authenticate.dart';

import '../const.dart';

class ScreenLogin extends StatefulWidget {
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final ServiceAuthenticate _serviceAuthenticate = ServiceAuthenticate();
  final _formKey = GlobalKey<FormState>();
  String email, password, error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: loading
            ? ScreenLoading()
            : Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Title
                        Text(
                          'MERCH 2020',
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w600),
                        ),
                        // Email TFF
                        Container(
                          width: 260.0,
                          margin: EdgeInsets.only(top: 30, bottom: 10),
                          child: TextFormField(
                            onChanged: (val) => email = val,
                            style: TextStyle(color: mainColor),
                            cursorColor: mainColor,
                            validator: (val) =>
                                (val.isEmpty || !val.contains('@'))
                                    ? 'Enter a valid email'
                                    : null,
                            decoration: _decorationTFF('email', Icons.person),
                          ),
                        ),
                        // Password TFF
                        Container(
                          width: 260.0,
                          margin: EdgeInsets.only(top: 20, bottom: 30),
                          child: TextFormField(
                            onChanged: (val) => password = val,
                            style: TextStyle(color: mainColor),
                            cursorColor: mainColor,
                            validator: (val) => (val.length < 6)
                                ? 'Enter a password with more than 6 characters'
                                : null,
                            decoration:
                                _decorationTFF('password', Icons.security),
                            obscureText: true,
                          ),
                        ),
                        // Log in BTN
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: FlatButton(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            color: mainColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading =
                                      true; // start ScreenLoading animation
                                });
                                dynamic result = await _serviceAuthenticate
                                    .signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'Sign in error';
                                    loading = false;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        // Error message
                        Container(
                          child: Text(error,
                              style: TextStyle(
                                  color: Color(0xffd32f2f), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  InputDecoration _decorationTFF(String hintText, IconData icon) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor, width: 2.0),
      ),
      prefixIcon: Icon(
        icon,
        color: mainColor,
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: mainColor.withOpacity(0.5)),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
