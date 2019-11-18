// 故事列表页面

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/pages/story/story_detail.dart';
import 'package:kidkid/providers/story_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:provider/provider.dart';

class Story extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<StoryProvider>(context);

    return Material(
      child: CupertinoPageScaffold(
      backgroundColor: GlobalColors.bgColor,
        navigationBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: GlobalColors.white,
          actionsForegroundColor: GlobalColors.red,
          middle: Text('故事列表')
        ),
        child: ListView.builder(
          itemCount: provider.storyList.length,
          itemBuilder: (context, index) {
            var model = provider.storyList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => StoryDetail(model, provider)
                ));
              },
              child: Container(
                height: 150.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.title),
                            Text(model.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))
                          ],
                        ),
                        Text(model.author)
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(model.text,
                      style: TextStyle(
                        fontWeight: FontWeight.w300
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 4,
                    )
                  ],
                ),
              )
            );
          },
        )
      )
    );
  }
}