// 画板界面 状态管理

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawListProvider with ChangeNotifier {
  List<String> myDraws;

  DrawListProvider() {
    myDraws = [];

    getMyDraw();
  }

  Future<void> getMyDraw() async {
    // myDraws = [];
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;
    var id = pref.getString("id");

    Http.get(API_MY_DRAW, params: {
      "UserId": id
    }, success: (res) {
      var jsonData = json.decode(res);

      for (var item in jsonData["data"]["lists"]) {
        myDraws.add(item["url"]);
      }

      notifyListeners();
    });
  }
}