// 画板界面 状态管理

import 'package:flutter/cupertino.dart';
import 'package:kidkid/models/draw_board/sticker_view_model.dart';

class DrawBoardProvider with ChangeNotifier {
  List<StickerViewModel> stickerLists;

  var dx = 100.0;
  var dy = 100.0;

  DrawBoardProvider() {
    stickerLists = [];
  }

  void addSticker(StickerViewModel stickerViewModel) {
    stickerLists.add(stickerViewModel);
    notifyListeners();
  }

  void update(int index, {var x = 0.0, var y = 0.0, var width = 0.0, var height = 0.0}) {
    if (index >= stickerLists.length) return ;

    stickerLists[index].x += x;
    stickerLists[index].y += y;
    stickerLists[index].width += width;
    stickerLists[index].height += height;

    notifyListeners();
  }

  void delete(int index) {
    if (index >= stickerLists.length) return ;
    
    stickerLists.removeAt(index);

    notifyListeners();
  }
}