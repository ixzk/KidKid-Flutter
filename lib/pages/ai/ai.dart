// 语音助手功能
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kidkid/providers/ai_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/title_line.dart';
import 'package:provider/provider.dart';
import 'package:xfvoice/xfvoice.dart';

class AI extends StatelessWidget {

  AIProvider provider;
  final FlutterSound flutterSound = new FlutterSound();
  final voice = XFVoice.shared;
  XFVoiceListener xfListener;

  AI() {
    voice.init(appIdIos: '5dd2546a', appIdAndroid: '5dd2546a');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    // param.asr_ptt = '0';   //取消注释可去掉标点符号
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
      },
      onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
        print(errInfo);
        print('onCompleted');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Material(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                width: double.infinity,
                height: 40.0,
                color: GlobalColors.bgColor,
                child: RaisedButton(
                  child: Icon(Icons.keyboard_voice, color: GlobalColors.white),
                  color: GlobalColors.red,
                  onPressed: () {
                  },
                  onHighlightChanged: (changed) {
                    provider.setVoicingState(!changed);
                    _onVoice();
                  },
                )
              )
            ],
          ),
        )
    );
  }

  Future _onVoice() async {
    if (provider.isVoicing) {
      // await flutterSound.startRecorder(null);
      voice.start(listener: xfListener);
    } else {
      // if (flutterSound.isRecording) {
      //   await flutterSound.stopRecorder();
      // }
      voice.stop();
    }
  }
}