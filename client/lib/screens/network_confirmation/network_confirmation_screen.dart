import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/wallet_provider.dart';
import 'package:provider/provider.dart';

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
                'While we are confirmation your transaction with Polygon network. Sometimes it may take more than 20 seconds please.',
                style:
                    Theme.of(context).textTheme.headline6!.copyWith(height: 2),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }),
    );
  }
}
