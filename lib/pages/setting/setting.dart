// 设置界面

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  
  var gameValue = true;
  var dayValue = false;
  var aiValue = true;

  _SettingState() {
    _loadValue();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          heroTag: "setting",
          transitionBetweenRoutes: false,
          border: null,
          backgroundColor: GlobalColors.white,
          actionsForegroundColor: GlobalColors.red,
          middle: Text('家长控制')
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('images/jiazhang2.png'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: GlobalColors.white,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("允许游戏", style: TextStyle(fontWeight: FontWeight.bold)),
                          Switch(
                            value: gameValue,
                            activeColor: GlobalColors.red,
                            onChanged: (value) {
                              _changedKeyValue("game", value);
                            },
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 50,
                    //   padding: EdgeInsets.only(left: 20.0, right: 40.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text("每天最多使用时间", style: TextStyle(fontWeight: FontWeight.bold)),
                    //       Text("2h", style: TextStyle(color: Colors.grey)),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("夜间禁止使用", style: TextStyle(fontWeight: FontWeight.bold)),
                          Switch(
                            value: dayValue,
                            activeColor: GlobalColors.red,
                            onChanged: (value) {
                              _changedKeyValue("day", value);
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("允许使用小K助手", style: TextStyle(fontWeight: FontWeight.bold)),
                          Switch(
                            value: aiValue,
                            activeColor: GlobalColors.red,
                            onChanged: (value) {
                              _changedKeyValue("ai", value);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }

  Future<void> _changedKeyValue(key, value) async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;
    
    pref.setBool(key, value);
  }

  _loadValue() async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;

    setState(() {
      gameValue = pref.getBool("game") ?? true;
      dayValue = pref.getBool("day") ?? false;
      aiValue = pref.getBool("ai") ?? true;
    });
  }
}