// Tabbar选项卡使用的结构

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidkid/pages/setting/setting.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/title_line.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final String title;
  final Widget body;
  final List<ChangeNotifier> providers;

  MainPage({this.title, this.body, this.providers});

  _MainPageState createState() => _MainPageState(this.title, this.body, this.providers);
}

class _MainPageState extends State<MainPage> {

  final String title;
  final Widget body;
  final List<ChangeNotifier> providers;

  String password;

  _MainPageState(this.title, this.body, this.providers);

  Widget build(BuildContext context) {

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          heroTag: this.title,
          transitionBetweenRoutes: false,
          border: null,
          backgroundColor: GlobalColors.bgColor,
          leading: TitleLine(title: '${title ?? ""}'),
          automaticallyImplyMiddle: false,
          trailing: GestureDetector(
            child: Icon(Icons.settings, color: Colors.grey, size: 24.0),
            onTap: () {
              _setting(context);
            },
          ),
        ),
        child: body
      ),
    );
  }

  void _setting(context) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return new Material(
          type: MaterialType.transparency,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: new Center(
              child: new SizedBox(
                width: 250.0,
                height: 200.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("请输入密码", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      TextField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        autofocus: true,
                        onChanged: (text) {
                          setState(() {
                            password = text;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("确认", style: TextStyle(color: GlobalColors.white)),
                            color: GlobalColors.red,
                            onPressed: () {
                              _verify();
                            },
                          ),
                          RaisedButton(
                            child: Text("取消"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ),
          )
        );
      }
    );
  }

  _verify() async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;
    String truePwd = pref.getString("pwd") ?? "";
    if (truePwd == password) {
      Navigator.pop(context);

      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Setting()
      ));
    } else {
      Fluttertoast.showToast(
        msg: "密码错误~",
        gravity: ToastGravity.CENTER
      );
    }
  }
}