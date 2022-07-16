import 'package:flutter/material.dart';
import 'package:in_pack/pages/list.dart';
import 'package:in_pack/pages/rooms.dart';
import 'package:in_pack/pages/profile.dart';

class BottomNavbar extends StatelessWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const BottomNavbar(
      {required this.onTap, required this.currentIndex, Key? key})
      : super(key: key);
  static const bodyWidgets = [
    RoomsPage(),
    ProfilePage(),
    ListPanel(),
  ];

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_outlined,
                color: Colors.brown,
              ),
              label: 'Чат',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.brown,
            ),
            backgroundColor: Colors.green,
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.brown,
              ),
              backgroundColor: Colors.blue,
              label: 'Пачки'),
        ],
        onTap: onTap,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.brown,
        selectedItemColor: Colors.brown,
        selectedIconTheme: const IconThemeData(opacity: 1),
        unselectedIconTheme: const IconThemeData(
          opacity: 0.7,
        ),
        currentIndex: currentIndex,
      );
}
