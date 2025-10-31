import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavProvider with ChangeNotifier {
  BottomNavProvider() : _controller = PersistentTabController(initialIndex: 0);

  final PersistentTabController _controller;

  PersistentTabController get controller => _controller;

  int get currentIndex => _controller.index;

  void onItemTapped(int index) {
    if (index == _controller.index) return;
    _controller.index = index;
    notifyListeners();
  }
}
