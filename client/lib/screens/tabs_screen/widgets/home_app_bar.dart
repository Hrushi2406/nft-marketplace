import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/wallet_provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(),

        ///WALLET
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            UpperCaseText(
              'Total Balance',
              style: Theme.of(context).textTheme.overline,
            ),
            SizedBox(height: rh(2)),
            Consumer<WalletProvider>(builder: (context, provider, child) {
              return UpperCaseText(
                formatBalance(provider.balance, 2) + ' MAT',
                key: ValueKey(provider.balance),
                style: Theme.of(context).textTheme.headline2,
              );
            }),
          ],
        ),
        SizedBox(width: rw(8)),

        SvgPicture.asset(
          'assets/images/wallet.svg',
          width: rf(32),
        ),
      ],
    );
  }
}
