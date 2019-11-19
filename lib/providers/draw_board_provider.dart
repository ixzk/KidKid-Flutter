// 画板界面 状态管理

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/models/draw_board/sticker_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawBoardProvider with ChangeNotifier {
  List<StickerViewModel> stickerLists;
  List<String> myDraws;
  List<Offset> points;  // 自定义画板
  var painterColor = Colors.black;     // 画笔颜色

  var dx = 100.0;
  var dy = 100.0;

  DrawBoardProvider() {
    stickerLists = [];
    points = [];
    myDraws = [];
  }

  void changePainerColor(Color color) {
    painterColor = color;
    notifyListeners();
  }

  void addSticker(StickerViewModel stickerViewModel) {
    stickerLists.add(stickerViewModel);
    notifyListeners();
  }

  void updateSticker(int index, {var x = 0.0, var y = 0.0, var width = 0.0, var height = 0.0}) {
    if (index >= stickerLists.length) return ;

    stickerLists[index].x += x;
    stickerLists[index].y += y;
    stickerLists[index].width += width;
    stickerLists[index].height += height;

    notifyListeners();
  }

  void deleteSticker(int index) {
    if (index >= stickerLists.length) return ;
    
    stickerLists.removeAt(index);

    notifyListeners();
  }

  void addPoint(Offset point) {
    points.add(point);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<void> getMyDraw() async {
    myDraws = [];
    print("myDraw");
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

      print(jsonData);
      print(myDraws.length);

      notifyListeners();
    });
  }
}