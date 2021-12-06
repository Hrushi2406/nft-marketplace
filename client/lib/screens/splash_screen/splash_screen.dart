import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfts/screens/edit_user_info_screen/edit_user_info_screen.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../tabs_screen/tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 750), _next);
  }

  _next() {
    // Navigation.pushReplacement(context, screen: const WalletInitScreen());
    Navigation.pushReplacement(context, screen: const EditUserInfoScreen());
    // Navigation.pushReplacement(context, screen: const TabsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: UpperCaseText(
              'NFT - Marketplace',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ],
      ),
    );
  }
}
