import 'package:flutter/material.dart';

import '../utils/colors.dart' as colors;

class BottomNavbar extends StatelessWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const BottomNavbar(
      {required this.onTap, required this.currentIndex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_outlined,
                color: Colors.brown,
              ),
              label: 'Chat',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.brown,
            ),
            backgroundColor: Colors.green,
            label: 'User',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.brown,
              ),
              backgroundColor: Colors.blue,
              label: 'Packs'),
        ],
        onTap: onTap,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.brown,
        selectedItemColor: colors.darkBrown,
        currentIndex: currentIndex,
      );
}
