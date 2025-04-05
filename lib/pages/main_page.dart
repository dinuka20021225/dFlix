import 'package:dmovies/pages/home_page.dart';
import 'package:dmovies/pages/now_playing_page.dart';
import 'package:dmovies/pages/search_page.dart';
import 'package:dmovies/pages/tv_shows_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;
  final _pages = [
    HomePage(),
    NowPlayingPage(),
    TvShowsPage(),
    SearchPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (value) {
          setState(() {
            _selectedPageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidCirclePlay),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.film),
            label: "TV Shows",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.magnifyingGlass),
            label: "Search",
          ),
        ],
        unselectedItemColor: Color.fromRGBO(19, 213, 255, 1),
        selectedItemColor: Color.fromRGBO(8, 158, 255, 1),
      ),
      body: _pages[_selectedPageIndex],
    );
  }
}
