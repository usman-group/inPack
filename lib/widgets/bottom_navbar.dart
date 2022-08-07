import 'package:flutter/material.dart';
import 'package:in_pack/pages/cigarette.dart';
import 'package:in_pack/utils/navbar_page.dart';
import 'package:in_pack/pages/rooms.dart';
import 'package:in_pack/pages/profile.dart';
import 'package:in_pack/pages/list.dart';
import 'package:in_pack/pages/map.dart';

class BottomNavbar extends StatelessWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const BottomNavbar(
      {required this.onTap, required this.currentIndex, Key? key})
      : super(key: key);
  static const bodyWidgets = <NavigationBarPage>[
    RoomsPage(),
    ProfilePage(),
    ListPage(),
    MapPage(),
    CigarettePage(),
  ];

  List<BottomNavigationBarItem> _itemsBuilder() {
    return bodyWidgets
        .map((page) => BottomNavigationBarItem(
            icon: page.icon,
            label: page.label,
            backgroundColor: Colors.brown[800]))
        .toList();
  }

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        showUnselectedLabels: true,
        items: _itemsBuilder(),
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
