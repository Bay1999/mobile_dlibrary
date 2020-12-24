import 'package:dlibrary/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:dlibrary/home.dart';
import 'package:dlibrary/bookmark.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Quicksand'),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return new SplashScreen(
      seconds: 8,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text(
        'D-Library',
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black38),
      ),
      image: new Image.asset("book.png"),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  int _currentIndex = 0;
  final List<Widget> _children = [Home(), Bookmark(), Setting()];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 254, 248, 85),
        selectedItemColor: Color.fromARGB(200, 0, 0, 0),
        unselectedItemColor: Color.fromARGB(100, 0, 0, 0),
        unselectedIconTheme: IconThemeData(size: 26),
        showUnselectedLabels: false,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        // type: BottomNavigationBarType.shifting,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            title: Text('Bookmark'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          // new BottomNavigationBarItem(
          //     icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }
}
