// 故事详情页面

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/models/record/record_model.dart';
import 'package:kidkid/models/sotry/story_model.dart';
import 'package:kidkid/providers/story_detail_provider.dart';
import 'package:kidkid/providers/story_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/kk_web_view.dart';
import 'package:kidkid/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class StoryDetail extends StatefulWidget {
  final StoryModel model;
  StoryDetail(this.model);
  _StoryDetailState createState() => new _StoryDetailState(model);
}

class _StoryDetailState extends State<StoryDetail> {

  final StoryModel model;
  final FlutterSound flutterSound = new FlutterSound();
  String path;
  StreamSubscription _playerSubscription;
  bool isVoicing = false;


  _StoryDetailState(this.model);

  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<StoryDetailProvider>(context);

    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          border: null,
          backgroundColor: GlobalColors.white,
          actionsForegroundColor: GlobalColors.red,
          middle: Text(model.title),
          // trailing: Icon(Icons.cloud_upload),
        ),
        child: Container(
          color: GlobalColors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: _getList(provider.recordList),
                )
              ),
              Container(
                height: 60.0,
                color: GlobalColors.bgColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(Icons.cloud_upload, color: (path == null ? Colors.grey: GlobalColors.red)),
                      onTap: () {
                        if (path == null) return ;
                        _upload();
                      },
                    ),
                    RaisedButton(
                      child: Icon(Icons.keyboard_voice, color: GlobalColors.white),
                      color: GlobalColors.red,
                      onPressed: () {
                      },
                      onHighlightChanged: (changed) {
                        setState(() {
                          isVoicing = !changed;
                        });
                        _onVoice();
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.play_circle_filled, color: (path == null ? Colors.grey: GlobalColors.red)),
                      onTap: () {
                        if (path == null) return ;
                        _play();
                      },
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

  Future _onVoice() async {
    if (!isVoicing) {
      await flutterSound.startRecorder(null);
    } else {
      String voicePath = await flutterSound.stopRecorder();
      setState(() {
        path = voicePath;
      });
    }
    print("录音");
  }

  Future _play() async {
    await flutterSound.startPlayer(null);
    // return print("file文件：$contents");
    await flutterSound.setVolume(1.0);
  }

  _upload() async {
    if (path != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog(text: '上传中');
        }
      );

      FormData formdata = FormData.fromMap({
        "file": MultipartFile.fromFile(path, filename: "sound.m4a"),
      });
      Response res = await Dio().post(
        //此处更换为自己的上传文件接口
        'http://39.97.174.216/upload.php',
        data: formdata,
      );

      var jsonData = json.decode(res.toString());
      var fileUrl = jsonData["data"]["path"];

      Http.post(API_UPLOAD_RECORD, params: {
        "userid": "1",
        "url": fileUrl,
        "StoryId": model.id,
        "title": model.title
      }, success: (res) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "上传成功",
          gravity: ToastGravity.BOTTOM,
        );
      });

    } else {
      Fluttertoast.showToast(
        msg: "还未录音",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  List<Widget> _getList(dataList) {
    List<Widget> list = [];

    list.add(Text(model.text,
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20.0),
    ));

    list.add(Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 100.0,
            height: 1.0,
            color: Colors.grey,
          ),
          Text("成品展示"),
          Container(
            width: 100.0,
            height: 1.0,
            color: Colors.grey,
          )
        ],
      ),
    ));

    for (RecordModel model in dataList) {
      list.add(
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(model.title),
                Icon(Icons.play_circle_filled)
              ],
            )
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => KKWebView(url: model.recording, title: "录音"),
            ));
          },
        )
      );
    }

    return list;
  }
}