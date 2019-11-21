import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/pages/ai/ai.dart';
import 'package:kidkid/pages/video/video.dart';
import 'package:kidkid/providers/ai_provider.dart';
import 'package:kidkid/providers/music_provider.dart';
import 'package:kidkid/providers/video_provider.dart';
import 'package:kidkid/util/global_colors.dart';
import 'package:kidkid/pages/main_page.dart';
import 'package:kidkid/pages/music/music.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedTabController extends CupertinoTabController {
  static SharedTabController shared = SharedTabController();
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  var canUse = true;
  var currentIndex = 0;

  CupertinoTabController controller;

  _AppState() {
    controller = SharedTabController.shared;
    _loadValue();
  }

  Widget build(BuildContext context) {

    if (!canUse) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            color: Color(0xFF333444),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  child: Image.asset('images/sun.png'),
                ),
                SizedBox(height: 15.0),
                Text("太晚啦", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                SizedBox(height: 10.0),
                Text("小太阳都睡着了呢~", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                SizedBox(height: 10.0),
                Text("明天再一起玩耍吧", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset('images/zzz.png'),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Text("test"),
            onPressed: () {
              setState(() {
                canUse = true;
              });
            },
          ),
        ),
      );
    }

    return MaterialApp(
      home: CupertinoTabScaffold(
        controller: controller,
        tabBar: CupertinoTabBar(
          border: null,
          currentIndex: currentIndex,
          backgroundColor: GlobalColors.white,
          items: [
            _getBottomNavigationBarItem(
              icon: Image.asset('images/i1.png'),
              activeIcon: Image.asset('images/i1_s.png')
            ),
            _getBottomNavigationBarItem(
              icon: Image.asset('images/voice.png'),
              activeIcon: Image.asset('images/ai.png')
            ),
            _getBottomNavigationBarItem(
              icon: Image.asset('images/i2.png'),
              activeIcon: Image.asset('images/i2_s.png')
            )
          ],
          iconSize: 25.0,
          activeColor: Color(0xFFFC1F50),
        ),
        tabBuilder: (context, index) {
          // return Container(
          //   color: GlobalColors.bgColor,
          // );
          Widget page;
          switch (index) {
            case 0: 
              page = MainPage(
                      title: '广场', 
                      body: MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            builder: (context) => MusicProvider(),
                          )
                        ],
                        child: Music(),
                      )
                    ); 
              break;
            case 1: page = MainPage(
                      title: '小K', 
                      body: MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            builder: (context) => AIProvider(),
                          )
                        ],
                        child: AI(controller),
                      )
                    ); 
            
              break;
            case 2: page = MainPage(
                      title: '视频', 
                      body: MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            builder: (context) => VideoProvider(),
                          )
                        ],
                        child: Video(),
                      )
                    ); 
              break;
          }

          return Container(
            color: GlobalColors.bgColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: page,
                ),
              ],
            ),
          );
        },
      )
    );
  }

  BottomNavigationBarItem _getBottomNavigationBarItem({Widget icon, Widget activeIcon}) {
    return BottomNavigationBarItem(
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 35.0,
            height: 35.0,
            child: icon
          ),
          ClipOval(
            child: Container(
              width: 5.0,
              height: 5.0,
              color: GlobalColors.white,
            )
          )
        ],
      ),
      activeIcon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 35.0,
            height: 35.0,
            child: activeIcon
          ),
          ClipOval(
            child: Container(
              width: 5.0,
              height: 5.0,
              color: GlobalColors.red,
            )
          )
        ],
      ),
      // title: Text(name)
    );
  }

  _loadValue() async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    SharedPreferences pref = await _pref;

    setState(() {
      canUse = !(pref.getBool("day") ?? false);
    });

    print(canUse);
  }

  changeIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }
  // AIBot 动画效果
  // Widget aibotTransition() {
  //   return 
  // }
}
