// 画板界面 状态管理

import 'package:flutter/cupertino.dart';
import 'package:kidkid/models/draw_board/sticker_view_model.dart';

class DrawBoardProvider with ChangeNotifier {
  List<StickerViewModel> stickerLists;

  DrawBoardProvider() {
    stickerLists = [];
  }

  void addSticker(StickerViewModel stickerViewModel) {
    stickerLists.add(stickerViewModel);
    notifyListeners();
  }
}