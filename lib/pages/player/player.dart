// 音乐播放器界面

import 'package:flutter/material.dart';
import 'package:kidkid/util/global_colors.dart';

class Player extends StatelessWidget {
  const Player({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        color: Color(0xFF232436),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.close, color: GlobalColors.white),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Container(
              width: size.width * 0.5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'GUARDINAS OF THE GALAXY', 
                style: TextStyle(
                  fontSize: 20, 
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            Text(
              'Various Artists',
              style: TextStyle(
                color: Colors.grey
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage('https://ci.xiaohongshu.com/bbbd8b31-6e03-5c36-a730-5f4015054714?imageView2/2/w/1080/format/jpg'),
                        fit: BoxFit.cover
                      )
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '00:00',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: 50.0,
                    max: 100.0,
                    min: 0.0,
                    activeColor: Color(0xFFFC1F49),
                    onChanged: (val) => {

                    },
                  ),
                ),
                Text(
                  '02:51',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/player/pre.png', width: 35, height: 35),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset('images/player/playing.png', width: 50, height: 50),
                ),
                Image.asset('images/player/next.png', width: 35, height: 35),
              ],
            )
          ],
        ),
      ),
    );
  }
}