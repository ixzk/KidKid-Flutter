import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kidkid/http/Http.dart';
import 'package:kidkid/models/cartoon/collection_model.dart';
import 'package:kidkid/pages/board/draw_board.dart';
import 'package:kidkid/pages/collection/Collection.dart';
import 'package:kidkid/pages/game/game.dart';
import 'package:kidkid/pages/music/music_more.dart';
import 'package:kidkid/pages/player/player.dart';
import 'package:kidkid/pages/story/story.dart';
import 'package:kidkid/providers/game_provider.dart';
import 'package:kidkid/providers/music_provider.dart';
import 'package:kidkid/providers/story_provider.dart';
import 'package:kidkid/providers/video_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/widgets/loading_dialog.dart';
import 'package:kidkid/widgets/title_more.dart';
import 'package:kidkid/pages/music/widgets/music_type_item.dart';
import 'package:kidkid/pages/music/widgets/music_folder_item.dart';
import 'package:kidkid/pages/music/widgets/music_cell.dart';
import 'package:provider/provider.dart';
import 'package:kidkid/providers/draw_board_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Music extends StatelessWidget {
  // 布局常量
  final navArea = 0;      // 金刚位
  final collectArea = 1;  // 歌单推荐
  final listsArea = 2;    // 内容区域

  @override
  Widget build(BuildContext context) {

    double itemWH = (MediaQuery.of(context).size.width - 20 * 2 - 20 * 2) / 3.0;

    var provider = Provider.of<MusicProvider>(context);
    
    var view = null;
    if (provider.songList.length == 0) {
      view = Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(),
        )
      );
    } else {
      var count = listsArea + provider.songList.length + 1;
      view = ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == navArea) {
            return Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  TitleMore(title: '玩具箱'),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MusicTypeItem(
                              name: '涂鸦板', 
                              image: Image.asset('images/music/huaban.png'), 
                              onTap: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider<DrawBoardProvider>.value(
                                    value: DrawBoardProvider(),
                                  )
                                ],
                                child:DrawBoard()
                              )
                            ),
                            MusicTypeItem(
                              name: '益智游戏', 
                              image: Image.asset('images/music/game.png'), 
                              onTap: () {
                                _game(context);
                              }),
                            MusicTypeItem(
                              name: '录制故事', 
                              image: Image.asset('images/music/jiazhang.png'), 
                              onTap: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider<StoryProvider>.value(
                                    value: StoryProvider(),
                                  )
                                ],
                                child:Story()
                              )
                            ),
                          ],
                        )
                      ],
                    )
                  ),              
                ],
              ),
            );
          } else if (index == collectArea) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TitleMore(title: '好听的故事合集')
                ),
                Container(
                  height: itemWH,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListView(
                    padding: EdgeInsets.only(left: 20.0),
                    scrollDirection: Axis.horizontal,
                    children: _getCollectionList(provider, context),
                  ),
                ),
              ],
            );
          } else if (index == listsArea){
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TitleMore(title: '当前最热', pressMore: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MusicMore(provider)
                ));
              },)
            );
          } else {
            if (index != count - 1) {
              var model = provider.songList[index - listsArea];
              return GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: MusicCell(model.title, desc: model.singer, image: Image.network(model.img, fit: BoxFit.cover)),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Player(model)
                  ));
                },
              );
            } else {
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
          }
        },
      );
    }

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

  List<Widget> _getCollectionList(MusicProvider provider, context) {
    List<Widget> list = [];
    for (CollectionModel model in provider.collectionList) {  
      list.add(
        GestureDetector(
          child: MusicFolderItem(name: model.title, image: Image.network(model.img, fit: BoxFit.fitHeight)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<VideoProvider>.value(
                    value: VideoProvider(collectId: model.id),
                  )
                ],
                child:Collection(model.title),
              )
            ));
          },
        )
    
      );
    }

    return list;
  }

  Future<void> _game(context) async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;

    bool canGame = pref.getBool("game") ?? true;
    
    if (canGame) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<GameProvider>.value(
              value: GameProvider(),
            )
          ],
          child:Game()
        )
      ));
    } else {
      Fluttertoast.showToast(
        msg: "现在禁止玩游戏！",
        timeInSecForIos: 2,
        fontSize: 20.0,
        backgroundColor: GlobalColors.red,
        textColor: GlobalColors.white,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}