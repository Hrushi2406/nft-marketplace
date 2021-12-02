import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import 'tabs/fav_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/user_tab.dart';
import 'widgets/bottom_nav_bar.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [const HomeTab(), const FavTab(), const UserTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }
}
