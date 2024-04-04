import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  AppBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      iconSize: 24.0,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13.0,
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13.0,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}