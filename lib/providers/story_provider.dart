// 故事状态管理

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/models/game/game_model.dart';
import 'package:kidkid/models/record/record_model.dart';
import 'package:kidkid/models/sotry/story_model.dart';

class StoryProvider with ChangeNotifier {

  List<StoryModel> storyList = [];

  List<RecordModel> recordList = [];
  
  int _page = 0;
  final int _maxPage = 10;

  StoryProvider() {
    getData();
  }

  void getData() {
    Http.get(
      API_STORY, 
      success: (result) {
        var jsonData = json.decode(result)["data"]["lists"];
        for (var storyJson in jsonData) {
          this.storyList.add(StoryModel.fromJson(storyJson));
        }

        notifyListeners();
      }
    );
  }

  void getRecordList(var id) {
    this.recordList = [];
    Http.get(
      API_RECORDING, 
      success: (result) {
        var jsonData = json.decode(result)["data"]["lists"];
        for (var recordJson in jsonData) {
          this.recordList.add(RecordModel.fromJson(recordJson));
        }

        notifyListeners();
      }
    );
  }
}