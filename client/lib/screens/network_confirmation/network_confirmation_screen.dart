import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/animations/fade_animation.dart';
import '../../locator.dart';
import '../../provider/app_provider.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/wallet_provider.dart';

class NetworkConfirmationScreen extends StatefulWidget {
  const NetworkConfirmationScreen({Key? key}) : super(key: key);

  @override
  _NetworkConfirmationScreenState createState() =>
      _NetworkConfirmationScreenState();
}

class _NetworkConfirmationScreenState extends State<NetworkConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WalletProvider>(builder: (context, provider, child) {
        if (provider.state == WalletState.success) {
          Provider.of<AppProvider>(context, listen: false).initialize();
          scheduleMicrotask(() {
            Navigation.pop(context);
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: rh(60)),
            Image.asset(
              'assets/images/loading1.gif',
            ),
            SizedBox(height: rh(space6x)),
            UpperCaseText(
              'Please wait',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: rh(space2x)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: space2x),
              child: UpperCaseText(
                'we are Confirming your transaction \n Allow upto 20 seconds',
                style:
                    Theme.of(context).textTheme.headline6!.copyWith(height: 2),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: rh(space6x)),
            FadeAnimation(
              duration: const Duration(milliseconds: 5000),
              intervalStart: 0.85,
              child: Buttons.text(
                context: context,
                text: 'process transaction in background',
                onPressed: () {
                  Navigation.pop(context);

                  Timer(const Duration(seconds: 16), () {
                    locator<AppProvider>().initialize();
                  });
                },
              ),
            ),
            SizedBox(height: rh(space1x)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: space2x),
              child: FadeAnimation(
                duration: const Duration(milliseconds: 5000),
                intervalStart: 0.85,
                child: UpperCaseText(
                  '*When you Skip, It may take time to reflect changes.',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(height: 2),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
