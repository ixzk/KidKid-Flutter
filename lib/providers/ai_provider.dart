// AI助手状态

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:kidkid/models/ai/ai_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AILocalType {
  draw, // 画板
  game, // 游戏
  music,  // 听歌
  video // 看视频
}

class AIProvider with ChangeNotifier {
  List<AIModel> chatList = [];
  bool isVoicing = false;

  bool canAI = true;

  double aiTouchLength = 100.0;
  double aiTouchHeight = 50.0;

  Timer _longTimer;
  Timer _shortTimer;

  int _isReading = -1;
  int _isPlaying = -1;

  final APP_SECRET = "57db87590bee4c3dabfd4604aaa28535";

  AIProvider() {
    loadValue();

    chatList.add(AIModel("你好，我是小K。", AICellType.bot));
    notifyListeners();
  }

  touchChangeLong() {
    _shortTimer?.cancel();
    _longTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (aiTouchLength == 200) {
        timer.cancel();
      } else {
        aiTouchLength += 5;
        aiTouchHeight += 0.5;
        notifyListeners();
      }
    });
  }

  read(int index) {
    chatList[index].notRead = false;
  }

  touchChangeShort() {
    _longTimer?.cancel();
    _shortTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (aiTouchLength == 100) {
        timer.cancel();
      } else {
        aiTouchLength -= 5;
        aiTouchHeight -= 0.5;
        notifyListeners();
      }
    });
  }

  loadValue() async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;

    canAI = pref.getBool("ai") ?? true;
    notifyListeners();
  }

  void setVoicingState(bool state) {
    isVoicing = state;
    notifyListeners();
  }

  void chat(String str) {
    var params = {
      "appkey": "038313f698144a5599d18f99e0649144",
      "api": "nli",
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "cusid": "kidkid",
      "rq": json.encode({
        "data_type": "stt",
        "data": {
          "input_type": 1,
          "text": str,
        }
      })
    };

    params["sign"] = generateMd5(APP_SECRET + "api=nli" + "appkey=${params['appkey']}" + "timestamp=${params['timestamp']}" + APP_SECRET);
    Http.get(API_AI_BOT, 
      params: params, 
      success: (res) {
        var jsonData = json.decode(res);
        print(res);
        List data = jsonData["data"]["nli"];
        if (data.length == 0) {
          addNew("小K还不理解你说的是什么呢", AICellType.bot);
        } else {
          String text = data[0]["desc_obj"]["result"];
          text = text.replaceAll("欧拉蜜", "小K");
          if (text == null || text.length == 0) {
            addNew("小K还不理解你说的是什么呢", AICellType.bot);
          } else {
            addNew(text, AICellType.bot);
          }
        }
      }
    );
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  void addNew(String text, AICellType type, [Function localCallBack]) {
    var model = AIModel(text, type);
    chatList.add(model);
    notifyListeners();

    // 对内容进行分析
    if (type == AICellType.my) {
      if (localCallBack != null) {
        if (RegExp('(画画|画板|绘图|绘画)').hasMatch(text)) { localCallBack(AILocalType.draw); return ;}
        if (RegExp('(打游戏|玩游戏)').hasMatch(text)) { localCallBack(AILocalType.game); return ;}
        if (RegExp('(听歌|听儿歌|唱歌|听故事)').hasMatch(text)) { localCallBack(AILocalType.music); return ;}
        if (RegExp('(视频|动画片)').hasMatch(text)) { localCallBack(AILocalType.video); return ;}
      }

      chat(text);
    }
  }
}