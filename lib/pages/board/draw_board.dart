// 画板

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:kidkid/http/API.dart';
import 'package:kidkid/http/Http.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kidkid/pages/board/widgets/darw_board_painter.dart';
import 'package:kidkid/pages/board/widgets/sticker_list.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/loading_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:kidkid/providers/draw_board_provider.dart';
import 'package:http_parser/src/media_type.dart';

class DrawBoard extends StatelessWidget {

  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DrawBoardProvider>(context);

    var size = MediaQuery.of(context).size;

    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: RepaintBoundary(
                    key: _repaintKey,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                        ),
                        CustomPaint(painter: DrawBoardPainter(provider.points)),
                        GestureDetector(
                          onPanUpdate: (details) {
                            RenderBox referenceBox = context.findRenderObject();
                            Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
                            provider.addPoint(localPosition);
                            provider.addSticker(null);
                            provider.notify();
                          },
                          onPanEnd: (details) {
                            provider.addPoint(null);
                            provider.changePainerColor(Colors.red);
                          },
                        ),
                        Stack(
                          children: _getStickerList(context),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: GlobalColors.white,
                    border: Border(top: BorderSide(width: 0.5, color: Colors.grey), bottom: BorderSide(width: 0.5, color: Colors.grey))
                  ),
                  child: StickerList(),
                )
              ],
            ),
          ),
          Positioned(
            top: 50.0,
            width: size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.arrow_back_ios, color: GlobalColors.red),
                    onTap: () => Navigator.pop(context),
                  ),

                  Row(
                    children: <Widget>[
                      // 上传列表
                      // GestureDetector(
                      //   child: Icon(Icons.list, color: GlobalColors.red),
                      //   onTap: () {

                      //   },
                      // ),
                      SizedBox(width: 20.0),
                      // 上传云端按钮
                      GestureDetector(
                        child: Icon(Icons.cloud_upload, color: GlobalColors.red),
                        onTap: () {
                          _uploadFile(context);
                        },
                      ),
                      SizedBox(width: 10.0),
                      // 保存图片按钮
                      GestureDetector(
                        child: Icon(Icons.save, color: GlobalColors.red),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return LoadingDialog(text: '保存中');
                            }
                          );

                          RenderRepaintBoundary boundary = _repaintKey.currentContext.findRenderObject();
                          var image = await boundary.toImage();
                          ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
                          var pngBytes = byteData.buffer.asUint8List();

                          if(Platform.isAndroid){
                            Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.photos]);
                            if (permissions[PermissionGroup.photos] != PermissionStatus.granted) {
                              Fluttertoast.showToast(
                                msg: "请打开相册权限",
                                gravity: ToastGravity.BOTTOM,
                              );
                              return ;
                            }
                          }

                          await ImageGallerySaver.saveImage(pngBytes);

                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: "保存成功",
                            gravity: ToastGravity.BOTTOM,
                          );

                          
                          // Directory appDocDir = await getApplicationDocumentsDirectory();
                          // String appDocPath = appDocDir.path;

                          // final unixTime = DateTime.now();
                          // final imageFile = File(path.join(appDocPath, '$unixTime.png'));
                          // await imageFile.writeAsBytes(pngBytes); 
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ),
        ],
      )
    );
  }

  List<Widget> _getStickerList(BuildContext context) {
    var provider = Provider.of<DrawBoardProvider>(context);

    List<Widget> lists = [];
    for (int i = 0; i < provider.stickerLists.length; i++) {
      var viewModel = provider.stickerLists[i];
      if (viewModel == null) continue; 
      lists.add(
        Positioned(
          left: viewModel.x,
          top: viewModel.y,
          child: GestureDetector(
            onPanUpdate: (details) {
              provider.updateSticker(i, x: details.delta.dx, y: details.delta.dy);
            },
            onLongPress: (){
              provider.deleteSticker(i);
            },
            child:Container(
              width: viewModel.width,
              height: viewModel.height,
              child: Image.asset(viewModel.imagePath),
            )
          ),
        )
      );
    }

    return lists;
  }

  Future _uploadFile(context) async {
    RenderRepaintBoundary boundary = _repaintKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog(text: '上传中');
      }
    );

    FormData formdata = FormData.fromMap({
      "file": MultipartFile.fromBytes(pngBytes, contentType: MediaType('image', 'png'), filename: 'test.png'),
    });
    Response res = await Dio().post(
      //此处更换为自己的上传文件接口
      'http://39.97.174.216/upload.php',
      data: formdata,
    );
    print(res);
    var jsonData = json.decode(res.toString());
    if (jsonData['code'] == 200) {
      var imgUrl = jsonData["data"]["path"];
      print(API_UPLOAD_PIC);
      
      var data = {
        "id": 1,
        "url": "http://39.97.174.216/" + imgUrl
      };
      print(data);
      Http.post(API_UPLOAD_PIC, params:data, success: (res) {
        Fluttertoast.showToast(
          msg: "保存成功",
          gravity: ToastGravity.BOTTOM,
        );
      });
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "保存失败，网络错误",
        gravity: ToastGravity.BOTTOM,
      );
    }

    print(res);
  }
}