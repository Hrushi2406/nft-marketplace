import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/animations/animations.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/app_provider.dart';
import '../create_wallet_screen/create_wallet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  _navigate(Widget screen) async {
    scheduleMicrotask(() {
      Navigation.pushReplacement(context, screen: screen);
    });
  }

  double width = 100;
  double height = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AppProvider>(builder: (context, provider, child) {
        if (provider.state == AppState.unauthenticated) {
          // _navigate(const WalletInitScreen());
          // return CreateWalletScreen();

          _navigate(const CreateWalletScreen());
        } else if (provider.state == AppState.loaded) {
          // _navigate(const TestMaticScreen());
          scheduleMicrotask(() {
            Navigation.pushReplacement(
              context,
              name: 'tabs_screen',
            );
          });
          // return TabsScreen();
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 650),
                curve: Curves.fastOutSlowIn,
                padding: const EdgeInsets.all(
                  space4x,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(space1x),
                  color: Theme.of(context).colorScheme.background,
                ),
                // alignment: Alignment.center,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UpperCaseText(
                        'Mintit',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize: rf(24),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 8,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              bottom: rh(170),
              left: 0,
              child: Align(
                alignment: Alignment.center,
                child: ScaleAnimation(
                  duration: const Duration(milliseconds: 750),
                  child: FadeAnimation(
                    duration: const Duration(milliseconds: 750),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: rf(95),
                      // style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: rh(60),
              left: 0,
              child: Align(
                alignment: Alignment.center,
                child: SlideAnimation(
                  begin: const Offset(-100, 0),
                  duration: const Duration(milliseconds: 450),
                  child: FadeAnimation(
                    duration: const Duration(milliseconds: 450),
                    child: UpperCaseText(
                      'Just a slide away',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
