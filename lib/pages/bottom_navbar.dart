import 'package:flutter/material.dart';
import 'rooms.dart';
import 'profile.dart';
import 'list.dart';
import 'map.dart';
import 'package:flutter/cupertino.dart';

class BottomNavbar extends StatelessWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const BottomNavbar(
      {required this.onTap, required this.currentIndex, Key? key})
      : super(key: key);
  static const bodyWidgets = [
    RoomsPage(),
    ProfilePage(),
    ListPage(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.chat_outlined,
                color: Colors.white,
              ),
              label: 'Чат',
              backgroundColor: Colors.brown[800]),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            backgroundColor: Colors.brown[500],
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.list,
                color: Colors.white,
              ),
              backgroundColor: Colors.brown[800],
              label: 'Пачки'),
          BottomNavigationBarItem(
              icon: const Icon(
                CupertinoIcons.map_pin_ellipse,
                color: Colors.white,
              ),
              backgroundColor: Colors.brown[500],
              label: 'Карта'),
        ],
        onTap: onTap,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(opacity: 1),
        unselectedIconTheme: const IconThemeData(
          opacity: 0.7,
        ),
        currentIndex: currentIndex,
      );
}
