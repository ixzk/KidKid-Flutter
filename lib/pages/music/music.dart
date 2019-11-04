import 'package:flutter/material.dart';
import 'package:kidkid/pages/board/draw_board.dart';
import 'package:kidkid/pages/game/game.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/title_more.dart';
import 'package:kidkid/pages/music/widgets/music_type_item.dart';
import 'package:kidkid/pages/music/widgets/music_folder_item.dart';
import 'package:kidkid/widgets/music_cell.dart';

class Music extends StatelessWidget {
  // 布局常量
  final navArea = 0;      // 金刚位
  final collectArea = 1;  // 歌单推荐
  final listsArea = 2;    // 内容区域

  @override
  Widget build(BuildContext context) {

    double itemWH = (MediaQuery.of(context).size.width - 20 * 2 - 20 * 2) / 3.0;

    return ListView.builder(
      itemCount: listsArea + 5,
      itemBuilder: (context, index) {
        if (index == navArea) {
          return Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                TitleMore(title: '玩具箱'),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          MusicTypeItem(name: '涂鸦板', image: Image.asset('images/music/huaban.png'), onTap: (context) => DrawBoard()),
                          MusicTypeItem(name: '益智游戏', image: Image.asset('images/music/game.png'), onTap: (context) => Game()),
                          MusicTypeItem(name: '家长中心', image: Image.asset('images/music/jiazhang.png')),
                        ],
                      )
                    ],
                  )
                ),              
              ],
            ),
          );
        } else if (index == collectArea) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TitleMore(title: '好听的故事合集')
              ),
              Container(
                height: itemWH,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: ListView(
                  padding: EdgeInsets.only(left: 20.0),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
                    MusicFolderItem(name: '那些年', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover))
                  ],
                ),
              ),
            ],
          );
        } else if (index == listsArea){
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TitleMore(title: '当前最热')
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: MusicCell('歌曲名', desc: '歌手介绍', image: Image.asset('images/demo/poster.png', fit: BoxFit.cover)),
          );
        }
      },
    );
  }
}