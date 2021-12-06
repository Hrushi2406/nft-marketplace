import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    Key? key,
    required this.titles,
    required this.tabs,
  }) : super(key: key);

  final List<String> titles;

  final List<Widget> tabs;

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.titles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //TAB TITLE CONFIG
        Center(
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorWeight: 1.4,
            indicatorColor: Theme.of(context).primaryColor,
            labelStyle: Theme.of(context).textTheme.headline3,
            labelPadding: const EdgeInsets.symmetric(horizontal: space2x),
            unselectedLabelStyle: Theme.of(context).textTheme.headline5,
            tabs: widget.titles
                .map<Widget>((title) => Tab(
                      text: title.toUpperCase(),
                      height: rh(30),
                    ))
                .toList(),
          ),
        ),

        // SizedBox(height: rh(space3x)),
        //TAB BAR VIEW
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: widget.tabs,
          ),
        ),
      ],
    );
  }
}
