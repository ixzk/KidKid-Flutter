// 画板

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kidkid/models/draw_board/sticker_view_model.dart';
import 'package:kidkid/pages/board/widgets/sticker_list.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:provider/provider.dart';
import 'package:kidkid/providers/draw_board_provider.dart';

class DrawBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: GlobalColors.bgColor,
          actionsForegroundColor: GlobalColors.red,
        ),
        child: Container(
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
      )
    );
  }

  List<Widget> _getStickerList(BuildContext context) {
    var provider = Provider.of<DrawBoardProvider>(context);
    
    List<Widget> lists = [];
    for (StickerViewModel viewModel in provider.stickerLists) {
      lists.add(
        Container(
          width: viewModel.width,
          height: viewModel.height,
          child: Image.asset(viewModel.imagePath)
        )
      );
    }

    return lists;
  }
}