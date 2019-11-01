import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidkid/util/global_colors.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: Material(
    //     child: Player(),
    //   ),
    // );
    return MaterialApp(
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          border: null,
          backgroundColor: GlobalColors.white,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('images/tabbar/music.png', width: 25.0, height: 25.0),
              activeIcon: Image.asset('images/tabbar/music_s.png', width: 25.0, height: 25.0),
              title: Text('音乐')
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/tabbar/discover.png', width: 25.0, height: 25.0),
              activeIcon: Image.asset('images/tabbar/discover_s.png', width: 25.0, height: 25.0),
              title: Text('发现')
            ),
            
          ],
          iconSize: 25.0,
          activeColor: Color(0xFFFC1F50),
        ),
        tabBuilder: (context, index) {
          return Container(
            color: GlobalColors.bgColor,
          );
          // Widget page;
          // switch (index) {
          //   case 0: page = MainPage(title: '音乐', body: Music()); break;
          //   case 1: page = MainPage(title: '歌单', body: Channel()); break;
          //   case 2: page = MainPage(title: '社区', body: Square()); break;
          //   case 3: page = MainPage(title: '我的', body: Mine()); break;
          // }

          // return Container(
          //   color: GlobalColors.bgColor,
          //   child: Column(
          //     children: <Widget>[
          //       Expanded(
          //         child: page,
          //       ),
          //       MiniPlayer()
          //     ],
          //   ),
          // );
        },
      )
    );
  }

  BottomNavigationBarItem _getBottomNavigationBarItem(String name, {Widget icon, Widget activeIcon}) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 25.0,
        height: 25.0,
        child: icon,
      ),
      activeIcon: Container(
        width: 25.0,
        height: 25.0,
        child: icon,
      ),
      title: Text(name)
    );
  }
}
