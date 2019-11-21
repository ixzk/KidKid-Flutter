import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/models/ai/ai_model.dart';
import 'package:kidkid/util/global_colors.dart';

class AILeftCell extends StatelessWidget {
  final AIModel model;
  final Function onTap;
  AILeftCell(this.model, this.onTap);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10.0),
      // color: GlobalColors.re,
      child: Row(
        children: <Widget>[
          Container(
            width: min(model.text.length * 16.0 + 40, size.width - 40 - 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(model.text, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            child: Icon(Icons.play_circle_filled, size: 30.0, color: GlobalColors.red),
            onTap: () {
              onTap(model.text);
            },
          )
        ],
      )
    );
  }
}