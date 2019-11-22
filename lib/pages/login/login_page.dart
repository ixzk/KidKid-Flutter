import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:kidkid/pages/app.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  WelcomePageState welcome;

  LoginPage({this.welcome});

  @override
  _LoginPageState createState() => new _LoginPageState(welcome: welcome);
}

class _LoginPageState extends State<LoginPage> {

  String username;
  String password;

  WelcomePageState welcome;

  _LoginPageState({this.welcome});

  bool isInputPassword = false;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: GlobalColors.bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/login" + (isInputPassword ? "2" : "1") + ".png", width: 250.0, fit: BoxFit.fill),
              Container(
                width: 250.0,
                height: 230.0,
                decoration: BoxDecoration(
                  color:GlobalColors.white,
                  // borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text("登录", style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "用户名",
                      ),
                      onTap: () {
                        setState(() {
                          isInputPassword = false;
                        });
                      },
                      onChanged: (text) {
                        setState(() {
                          username = text;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "密码",
                      ),
                      onTap: () {
                        setState(() {
                          isInputPassword = true;
                        });
                      },
                      onChanged: (text) {
                        setState(() {
                          password = text;
                        });
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            color: GlobalColors.red,
                            child: Text("登录", style: TextStyle(color: GlobalColors.white)),
                            onPressed: () {
                              _login();
                            },
                          ),
                          RaisedButton(
                            color: Colors.grey,
                            child: Text("注册", style: TextStyle(color: GlobalColors.white)),
                            onPressed: () {
                              _register();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        )
      ),
    );
  }

  void _login() {
    Fluttertoast.showToast(
      msg: "登录中",
      gravity: ToastGravity.BOTTOM,
    );   

    FormData data = FormData.fromMap({
      "username": username,
      "password": password,
    });

    print(API_LOGIN);
    Http.post(API_LOGIN, data: data, success: (res) async {
      var jsonData = json.decode(res);

      if (jsonData["code"] == 200 || jsonData["code"] == "200") {
        Future<SharedPreferences> _pref = SharedPreferences.getInstance();
        SharedPreferences pref = await _pref;
        pref.setString("id", jsonData["data"]["id"].toString());
        pref.setString("name", jsonData["data"]["name"]);
        pref.setString("pwd", password);
        pref.setBool("login", true);

        Fluttertoast.showToast(
          msg: "登录成功",
          gravity: ToastGravity.BOTTOM,
        );

        welcome.updateLogin();

      } else {
        Fluttertoast.showToast(
          msg: "用户名或密码错误",
          gravity: ToastGravity.BOTTOM,
        );
      }
    
    });
  
  }

  void _register() {
    Fluttertoast.showToast(
      msg: "注册中",
      gravity: ToastGravity.BOTTOM,
    );

    print(API_REGISTER);
    FormData data = FormData.fromMap({
      "username": username,
      "password": password,
      "tel": "",
      "mail": ""
    });
    Http.post(API_REGISTER, data: data, success: (res) {
      print(res);
      Fluttertoast.showToast(
        msg: "注册成功",
        gravity: ToastGravity.BOTTOM,
      );
    });
  }
}
