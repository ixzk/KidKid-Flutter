// 故事状态管理

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/models/game/game_model.dart';
import 'package:kidkid/models/record/record_model.dart';
import 'package:kidkid/models/sotry/story_model.dart';

class StoryDetailProvider with ChangeNotifier {

  List<RecordModel> recordList = [];

  StoryDetailProvider(id) {
    getData(id);
  }

  void getData(id) {
    Http.get(
      API_RECORDING, 
      params: {
        "StoryId": id
      },
      success: (result) {
        var jsonData = json.decode(result)["data"]["lists"];
        for (var recordJson in jsonData) {
          this.recordList.add(RecordModel.fromJson(recordJson));
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