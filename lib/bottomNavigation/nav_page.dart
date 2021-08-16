import 'package:flutter/material.dart';
import 'package:youtubeapi/screens/home_screen.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedIndex = 0;
  // static const double _playerMinheight = 60.0;

  final List _screen = [
    HomeScreen(),
    Text("asdasd"),
    Text("asdasd"),
    Text("asdasd"),
    Text("asdasd"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 10.0,
        selectedFontSize: 10.0,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
            ),
            activeIcon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            activeIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.subscriptions_outlined,
            ),
            activeIcon: Icon(Icons.subscriptions),
            label: "Subscriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.video_library_outlined,
            ),
            activeIcon: Icon(Icons.video_library),
            label: "Library",
          ),
        ],
      ),
    );
  }
}
