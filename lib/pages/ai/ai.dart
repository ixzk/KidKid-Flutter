// 语音助手功能
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidkid/app.dart';
import 'package:kidkid/models/ai/ai_model.dart';
import 'package:kidkid/pages/ai/widgets/ai_left_cell.dart';
import 'package:kidkid/pages/ai/widgets/ai_right_cell.dart';
import 'package:kidkid/pages/board/draw_board.dart';
import 'package:kidkid/pages/game/game.dart';
import 'package:kidkid/providers/ai_provider.dart';
import 'package:kidkid/providers/draw_board_provider.dart';
import 'package:kidkid/providers/game_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/title_line.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:xfvoice/xfvoice.dart';

class AI extends StatelessWidget {

  AIProvider provider;
  final FlutterSound flutterSound = new FlutterSound();
  final voice = XFVoice.shared;
  XFVoiceListener xfListener;

  var lastCount = 0;
  ScrollController _controller = ScrollController();

  AudioPlayer _audioPlayer = AudioPlayer();

  final CupertinoTabController tabController;

  BuildContext context;

  AI(this.tabController) {
    voice.init(appIdIos: '5dd2546a', appIdAndroid: '5dd2546a');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0';   //取消注释可去掉标点符号
    param.asr_audio_path = 'audio.pcm';
    param.result_type = 'json'; //可以设置plain
    final map = param.toMap();
    // map['dwa'] = 'wpgs';        //设置动态修正，开启动态修正要使用json类型的返回格式
    voice.setParameter(map);

    xfListener = XFVoiceListener(
      onVolumeChanged: (volume) {
        print('$volume');
      },
      onResults: (String result, isLast) {
        print("识别成功");
        print(result.toString());
        print("????");
        var jsonData = json.decode(result);
        print("2222");
        var str = "";
        for (Map item in jsonData["ws"]) {
          print(item);
          for (Map item2 in item["cw"]) {
            str += item2["w"];
          }
        }

        print("识别结果"+ str);

        if (str.length == 0) {
          Fluttertoast.showToast(
            msg: "我好像没听清",
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          provider.addNew(str, AICellType.my, (AILocalType type) {
            print("本地逻辑");
            print(type.toString());
            if (type == AILocalType.draw) {
              _push(false);
            } else if (type == AILocalType.game) {
              _push(true);
            } else if (type == AILocalType.music) {
              SharedTabController.shared.index = 0;
            } else if (type == AILocalType.video) {
              SharedTabController.shared.index = 2;
            }
          });
        }
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        print(errInfo);
        print('onCompleted');
      }
    );

    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    provider = Provider.of<AIProvider>(context);
    provider.loadValue();

    if (!provider.canAI) {
      return Material(
        child: Container(
          color: GlobalColors.bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset('images/bot.png'),
                ),
                SizedBox(height: 20.0),
                Text("小K睡着了💤", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          ),
        ),
      );
    }

    if (provider.chatList.length != 1 && provider.chatList.length > lastCount) {
      lastCount = provider.chatList.length;
      var last = provider.chatList.last;
      if (last.type == AICellType.bot && last.notRead) {
        // 机器人自动朗读
        _playVoice(last.text, null);
        provider.read(lastCount - 1);
        if (_controller.hasClients) {
          Timer(Duration(microseconds: 1000), () {
            _controller.jumpTo(_controller.position.maxScrollExtent);
          });
        }
      }
    }

    return Material(
        color: GlobalColors.bgColor,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: provider.chatList.length,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    var model = provider.chatList[index];
                    if (model.type == AICellType.bot) {
                      return AILeftCell(model, (text){ _playVoice(text, 1); });
                    } else {
                      return AIRightCell(model, (text){ _playVoice(text, 0); });
                    }
                  },
                )
              ),
              Container(
                width: provider.aiTouchLength,
                height: provider.aiTouchHeight,
                color: GlobalColors.bgColor,
                child: GestureDetector(
                  child: Container(
                    child: Icon(Icons.keyboard_voice, color: GlobalColors.white),
                    decoration: BoxDecoration(
                      color: GlobalColors.red,
                      borderRadius: BorderRadius.circular(provider.aiTouchHeight * 0.5)
                    ),
                  ),
                  onLongPressStart: (detail) {
                    print("开始长按");
                    provider.touchChangeLong();
                    _onVoice(true);
                  },
                  onLongPressEnd: (detail) {
                    print("结束长按");
                    provider.touchChangeShort();
                    _onVoice(false);
                  }
                )
              ),
              SizedBox(height: 10.0)
                
                // child: RaisedButton(
                //   child: Icon(Icons.keyboard_voice, color: GlobalColors.white),
                //   color: GlobalColors.red,
                //   onPressed: () {
                //   },
                //   onHighlightChanged: (changed) {
                //     provider.setVoicingState(!changed);
                //     _onVoice();
                //   },
                // )
            ],
          ),
        )
    );
  }

  Future _onVoice(bool start) async {
    if (start) {
      // await flutterSound.startRecorder(null);
      _audioPlayer.stop();
      voice.start(listener: xfListener);
    } else {
      // if (flutterSound.isRecording) {
      //   await flutterSound.stopRecorder();
      // }
      voice.stop();
    }
  }

  _playVoice(String text, int type) {
    _audioPlayer.stop();
    _audioPlayer.play("http://fanyi.baidu.com/gettts?lan=zh&ie=UTF-8&spd=6&source=web&text=" + text ?? "暂无未读消息");
  }

  _push(bool game) {
    if (game) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<GameProvider>.value(
              value: GameProvider(),
            )
          ],
          child:Game()
        )
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<DrawBoardProvider>.value(
              value: DrawBoardProvider(),
            )
          ],
          child:DrawBoard()
        )
      ));
    }
  }

  Future<void> _checkPermission() async {
    if(Platform.isAndroid){
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
      if (permissions[PermissionGroup.microphone] != PermissionStatus.granted) {
        Fluttertoast.showToast(
          msg: "请打开麦克风权限",
          gravity: ToastGravity.BOTTOM,
        );
        return ;
      }
    }
  }
}