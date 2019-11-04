// 画板

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kidkid/util/global_colors.dart';

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
                child: Container(),
              ),
              Container(
                height: 100,
                color: Colors.red,
              )
            ],
          ),
        )
      )
    );
  }
}