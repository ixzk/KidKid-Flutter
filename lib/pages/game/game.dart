// 游戏列表

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/pages/game/widgets/game_cell.dart';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: GlobalColors.white,
          actionsForegroundColor: GlobalColors.red,
          middle: Text('益智游戏')
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return GameCell(title: '小兔子', desc: '益智', content: '内容简介', image: Image.asset('images/demo/poster.png'));
          },
        )
      )
    );
  }
}