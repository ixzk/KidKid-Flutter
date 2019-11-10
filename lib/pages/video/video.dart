// 视频页

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kidkid/pages/video/video_player.dart';
import 'package:kidkid/pages/video/widgets/video_cell.dart';
import 'package:kidkid/providers/video_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/title_more.dart';
import 'package:provider/provider.dart';

class Video extends StatelessWidget {

  final swiperArea = 0;
  final listArea = 1; 

  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<VideoProvider>(context);

    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: (provider.videoList.length / 2).ceil() + listArea,
        itemBuilder: (context, index) {
          if (index == swiperArea) {
            // return Container();
            // return ClipRRect(
            //   borderRadius: BorderRadius.circular(10.0),
            //   child: Container(
            //     height: 150.0,
            //     child: Swiper(
            //       itemCount: 3,
            //       pagination: SwiperPagination(
            //         builder: DotSwiperPaginationBuilder(
            //           color: Colors.grey,
            //           activeColor: GlobalColors.red
            //         )
            //       ),
            //       itemBuilder: (context, index) {
            //         var ad = provider.adList[index];
            //         return Image.network(
            //           ad,
            //           fit: BoxFit.fill,
            //         );
            //       },
            //     )
            //   )
            // );
            return Container();
          } else if (index == listArea) {
            return Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: TitleMore(title: '好看的动画片')
            );
          } else {
            var leftModel = provider.videoList[(index - listArea) * 2];
            // var rightModel = provider.videoList[(index - listArea) * 2 + 1];
            // return Container(
            //   // color: Colors.red,
            //   padding: EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           child: GestureDetector(
            //             child: VideoCell(leftModel),
            //             onTap: () {
            //               Navigator.push(context, MaterialPageRoute(
            //                 builder: (context) => VideoPlayer(leftModel.cartoon)
            //               ));
            //             },
            //           ),
            //         )
            //       ),
            //       SizedBox(width: 30.0),
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           child: GestureDetector(
            //             child: VideoCell(rightModel),
            //             onTap: () {
            //               Navigator.push(context, MaterialPageRoute(
            //                 builder: (context) => VideoPlayer(rightModel.cartoon)
            //               ));
            //             },
            //           ),
            //         )
            //       ),
            //     ]
            //   ),
            // );

            // return GestureDetector(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20.0),
            //     child: MusicCell(model.title, desc: model.singer, image: Image.network(model.img, fit: BoxFit.cover)),
            //   ),
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (context) => Player(model)
            //     ));
            //   },
            // );

            return GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: VideoCell(leftModel),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => VideoPlayer(leftModel.cartoon)
                ));
              },
            );

          //   var model = provider.songList[index - listsArea];
          // return GestureDetector(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20.0),
          //     child: MusicCell(model.title, desc: model.singer, image: Image.network(model.img, fit: BoxFit.cover)),
          //   ),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(
          //         builder: (context) => Player(model)
          //     ));
          //   },
          // );
          }
        }
    );
  }
}