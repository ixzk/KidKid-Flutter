import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/providers/draw_board_provider.dart';
import 'package:kidkid/providers/draw_list_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:provider/provider.dart';

class DrawList extends StatelessWidget {

  DrawList() {
  }

    @override
  Widget build(BuildContext context) {

    var provider = Provider.of<DrawListProvider>(context);

    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: GlobalColors.white,
          actionsForegroundColor: GlobalColors.red,
          middle: Text('我的画板')
        ),
        child: _getContentWidget(context)
      )
    );
  }

  Widget _getContentWidget(BuildContext context) {
    var provider = Provider.of<DrawListProvider>(context);

    var size = MediaQuery.of(context).size;
    print("更新" + provider.myDraws.length.toString());
    if (provider.myDraws.length == 0) {
      return Container(
        height: size.height,
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
        itemCount: provider.myDraws.length,
        itemBuilder: (context, index) {
          String url = provider.myDraws[index];
          return Container(
            width: size.width - 40,
            height: size.height - 40 - 60,
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: GlobalColors.white,
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover
              )
            ),
          );
        },
      );
    }
  }
}