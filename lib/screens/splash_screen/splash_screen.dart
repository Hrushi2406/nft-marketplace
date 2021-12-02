import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../wallet_init_screen/wallet_init_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 450), _next);
  }

  _next() {
    Navigation.push(context, screen: const WalleInitScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UpperCaseText(
            'NFT - Marketplace',
            style: Theme.of(context).textTheme.headline2,
          ),
        ],
      ),
    );
  }
}
