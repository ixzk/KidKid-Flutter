// 游戏列表

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/models/cartoon/cartoon_model.dart';
import 'package:kidkid/models/game/game_model.dart';
import 'package:kidkid/pages/music/widgets/music_cell.dart';
import 'package:kidkid/providers/video_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/pages/game/widgets/game_cell.dart';
import 'package:kidkid/widgets/kk_web_view.dart';
import 'package:provider/provider.dart';
import 'package:kidkid/providers/game_provider.dart';

class Collection extends StatelessWidget {

  final title;

  Collection(this.title);

  @override
  Widget build(BuildContext context) {

    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          border: null,
          backgroundColor: GlobalColors.white,
          actionsForegroundColor: GlobalColors.red,
          middle: Text(title)
        ),
        child: Container(
          color: GlobalColors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: _getContentWidget(context),
        )
      )
    );
  }

  Widget _getContentWidget(BuildContext context) {
    var provider = Provider.of<VideoProvider>(context);
    var height = MediaQuery.of(context).size.height;
    if (provider.videoList.length == 0) {
      return Container(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("暂无数据", style: TextStyle(fontSize: 12.0, color: Colors.grey))
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: provider.videoList.length,
        itemBuilder: (context, index) {
          CartoonModel model = provider.videoList[index];
          return GestureDetector(
            child: MusicCell(model.title, desc: "", image: Image.network(model.img)),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => KKWebView(title: model.title, url: model.cartoon)
                )
              );
            },
          );
        },
      );
    }
  }
}