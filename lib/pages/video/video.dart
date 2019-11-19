// 视频页

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kidkid/pages/video/video_player.dart';
import 'package:kidkid/pages/video/widgets/video_cell.dart';
import 'package:kidkid/providers/video_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/kk_web_view.dart';
import 'package:kidkid/widgets/title_more.dart';
import 'package:provider/provider.dart';

class Video extends StatelessWidget {

  final swiperArea = 0;
  final listArea = 1; 

  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<VideoProvider>(context);

    var count = (provider.videoList.length / 2).ceil() + listArea + 1;
    var view = ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == swiperArea) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 150.0,
                child: Swiper(
                  itemCount: 3,
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: GlobalColors.red
                    )
                  ),
                  itemBuilder: (context, index) {
                    var ad = provider.adList[index];
                    return Image.network(
                      ad,
                      fit: BoxFit.fill,
                    );
                  },
                )
              )
            );
          } else if (index == listArea) {
            return Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: TitleMore(title: '好看的动画片')
            );
          } else {

            if (index == count - 1) {
              return GestureDetector(
                child: Container(
                  height: 40.0,
                  child: Center(
                    child: Text((provider.hasNext ? "加载更多" : "没有更多了"), style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ),
                ),
                onTap: () {
                  provider.loadMore();
                },
              );
            }

            var leftModel = provider.videoList[(index - listArea) * 2];
            var rightModel = provider.videoList[(index - listArea) * 2 + 1];
            return Container(
              // color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: GestureDetector(
                        child: VideoCell(leftModel),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => KKWebView(title: leftModel.title, url: leftModel.cartoon)
                          ));
                        },
                      ),
                    )
                  ),
                  SizedBox(width: 30.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: GestureDetector(
                        child: VideoCell(rightModel),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => KKWebView(title: rightModel.title, url: rightModel.cartoon)
                          ));
                        },
                      ),
                    )
                  ),
                ]
              ),
            );
          }
        }
    );

    return Scaffold(
      body: view,
      backgroundColor: GlobalColors.bgColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlobalColors.red,
        child: Icon(Icons.refresh),
        mini: true,
        onPressed: () {
          provider.getData();
        },
      ),
    );
  }
}