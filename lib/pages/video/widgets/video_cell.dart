import 'package:flutter/material.dart';
import 'package:kidkid/util/global_colors.dart';

class VideoCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      height: 120.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Colors.grey,
              height: 100.0,
            )
          ),
          Text('学加减法', style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}