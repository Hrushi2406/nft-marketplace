import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../tabs_screen/tabs_screen.dart';
import '../wallet_init_screen/wallet_init_screen.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({Key? key}) : super(key: key);

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  //Navigate to Wallet Init Screen
  _navigate() {
    Navigation.push(
      context,
      screen: const WalletInitScreen(),
    );
  }

  _createWallet() {
    Navigation.push(
      context,
      screen: const TabsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: rh(200)),
            Center(
              child: UpperCaseText(
                'Choose Wallet Type',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: rh(100)),
            Buttons.flexible(
              width: double.infinity,
              context: context,
              text: 'I have a private Key',
              onPressed: _navigate,
            ),
            SizedBox(height: rh(space3x)),
            CustomOutlinedButton(
              width: double.infinity,
              text: 'Create a new wallet',
              onPressed: _createWallet,
            ),
          ],
        ),
      ),
    );
  }
}
