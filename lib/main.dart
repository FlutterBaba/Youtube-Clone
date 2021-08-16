import 'package:flutter/material.dart';

import 'bottomNavigation/nav_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter YouTube API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
        ),
      ),
      home: NavPage(),
    );
  }
}
