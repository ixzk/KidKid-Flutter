// 画板

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kidkid/pages/board/widgets/sticker_list.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:provider/provider.dart';
import 'package:kidkid/providers/draw_board_provider.dart';

class DrawBoard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 50.0,
            left: 10.0,
            child: GestureDetector(
              child: Icon(Icons.arrow_back_ios, color: GlobalColors.red),
              onTap: () => Navigator.pop(context),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: _getStickerList(context),
                  ),
                ),
                Container(
                  height: 100,
                  child: StickerList(),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  List<Widget> _getStickerList(BuildContext context) {
    var provider = Provider.of<DrawBoardProvider>(context);

    List<Widget> lists = [];
    for (int i = 0; i < provider.stickerLists.length; i++) {
      var viewModel = provider.stickerLists[i];
      lists.add(
        Positioned(
          left: viewModel.x,
          top: viewModel.y,
          child: GestureDetector(
            onPanUpdate: (details) {
              provider.update(i, x: details.delta.dx, y: details.delta.dy);
            },
            onLongPress: (){
              provider.delete(i);
            },
            child:Container(
              width: viewModel.width,
              height: viewModel.height,
              child: Image.asset(viewModel.imagePath),
            )
          ),
        )
      );
    }

    return lists;
  }
}