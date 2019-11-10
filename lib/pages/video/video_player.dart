// 视频播放器
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatelessWidget {

  final String url;

  VideoPlayer(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Chewie(
          controller: ChewieController(
            videoPlayerController: VideoPlayerController.network(url),
            aspectRatio: 16 / 9,
            autoPlay: !true,
            looping: true,
            showControls: true,
            // 占位图
            placeholder: new Container(
                color: Colors.grey,
            ),

            // 是否在 UI 构建的时候就加载视频
            autoInitialize: !true,

            // 拖动条样式颜色
            materialProgressColors: new ChewieProgressColors(
                playedColor: Colors.red,
                handleColor: Colors.blue,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.lightGreen,
            ),
          ),
        ),
      )
    );
  }
}