import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/app_provider.dart';
import '../create_wallet_screen/create_wallet_screen.dart';
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

    // Timer(const Duration(milliseconds: 750), _next);
  }

  _navigate(Widget screen) {
    scheduleMicrotask(() {
      Navigation.pushReplacement(context, screen: screen);
    });

    // Navigation.pushReplacement(context, screen: const WalletInitScreen());
    // Navigation.pushReplacement(context, screen: const TabsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(builder: (context, provider, child) {
        if (provider.state == AppState.unauthenticated) {
          // _navigate(const WalletInitScreen());
          // return CreateWalletScreen();
          _navigate(const CreateWalletScreen());
        } else if (provider.state == AppState.loaded) {
          _navigate(const TabsScreen());
          // return TabsScreen();
        }
        return Column(
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
        );
      }),
    );
  }
}
