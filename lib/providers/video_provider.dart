import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/models/cartoon/cartoon_model.dart';

class VideoProvider with ChangeNotifier {
  List<CartoonModel> videoList = [];
  List<String> adList = [
    "http://zjimg.5054399.com/allimg/191106/15_191106173649_1.jpg",
    "http://zjimg.5054399.com/allimg/190904/15_190904150636_1.jpg",
    "http://zjimg.5054399.com/allimg/191108/15_191108134936_1.jpg"
  ];

  final String collectId;

  bool hasNext = false;
  var page = 1;

  VideoProvider({this.collectId}) {
    getData();
  }

  void loadMore() {
    if (this.collectId == null) {
      Http.get(
        API_CARTOON_LIST,
        params: {
          "Page": (++page)
        },
        success: (result) {
          var jsonData = json.decode(result);
          hasNext = (jsonData["has_next"] == "True");
          for (var videoJson in jsonData["data"]["lists"]) {
            this.videoList.add(CartoonModel.fromJson(videoJson));
          }
          
          notifyListeners();
        },
        failure: (error) {
          print(error);
        }
      );
    } else {
      Http.get(
        API_COLLECTION_DETAIL,
        params: {
          "CollectionId": this.collectId,
          "Page": (++page)
        },
        success: (result) {
          var jsonData = json.decode(result);
          hasNext = (jsonData["has_next"] == "True");
          for (var videoJson in jsonData["data"]["lists"]) {
            this.videoList.add(CartoonModel.fromJson(videoJson));
          }
          
          notifyListeners();
        },
        failure: (error) {
          print(error);
        }
      );
    }
  }

  void getData() {
    videoList = [];
    notifyListeners();
    if (this.collectId == null) {
      Http.get(
        API_CARTOON_LIST,
        success: (result) {
          var jsonData = json.decode(result);
          hasNext = (jsonData["has_next"] == "True");
          for (var videoJson in jsonData["data"]["lists"]) {
            this.videoList.add(CartoonModel.fromJson(videoJson));
          }
          
          notifyListeners();
        },
        failure: (error) {
          print(error);
        }
      );
    } else {
      Http.get(
        API_COLLECTION_DETAIL,
        params: {
          "CollectionId": this.collectId
        },
        success: (result) {
          var jsonData = json.decode(result);
          hasNext = (jsonData["has_next"] == "True");
          for (var videoJson in jsonData["data"]["lists"]) {
            this.videoList.add(CartoonModel.fromJson(videoJson));
          }
          
          notifyListeners();
        },
        failure: (error) {
          print(error);
        }
      );
    }
  }
}