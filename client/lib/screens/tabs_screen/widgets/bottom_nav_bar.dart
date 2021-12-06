import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/utils.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final int currentIndex;

  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      iconSize: rf(24),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          activeIcon: Icon(Iconsax.home_15),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Iconsax.heart),
          activeIcon: Icon(Iconsax.heart5),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Iconsax.user),
          activeIcon: SvgPicture.asset(
            "assets/images/user-active.svg",
            width: rf(24),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
