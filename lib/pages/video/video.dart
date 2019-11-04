// 视频页

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kidkid/pages/video/widgets/video_cell.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/title_more.dart';

class Video extends StatelessWidget {

  final swiperArea = 0;
  final listArea = 1; 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == swiperArea) {
            // return SwiperPagination(
            //   builder: DotSwiperPaginationBuilder(
            //     color: Colors.grey,
            //     activeColor: GlobalColors.red
            //   )
            // );
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
                    return Image.network(
                      "http://via.placeholder.com/350x150",
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
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: VideoCell()
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    flex: 1,
                    child: VideoCell()
                  )
                ]
             ),
            );
          }
        }
      ),
    );
  }
}