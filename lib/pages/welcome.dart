import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidkid/app.dart';
import 'package:kidkid/pages/login/login_page.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/loading_dialog.dart';

import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  static String tag = 'welcome-page';
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  
  bool isLogin = false;
  bool loginPage = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {

    if (loginPage) {
      return LoginPage();
    } else {
      if (isLogin) {
        return App();
      } else {
        return Material(
          child: Container(
            color: GlobalColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('images/logo_v2.0.png'),
                )
              ],
            ),
          ),
        );
      }
    }
  }

  Future checkLogin() async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;
    bool _isLogin = pref.getBool("login") ?? false;
    // if (_isLogin != null && _isLogin) {
    if (true) {
      Fluttertoast.showToast(
        msg: "自动登录中",
        gravity: ToastGravity.BOTTOM,
      );

      Timer(Duration(seconds: 1), () {
        setState(() {
          isLogin = true;
        });
      });
    } else {
      Timer(Duration(seconds: 1), () {
        setState(() {
          loginPage = true;
        });
      });
    }
  }
}
