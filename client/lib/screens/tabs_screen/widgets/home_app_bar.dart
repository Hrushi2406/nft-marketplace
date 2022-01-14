import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/wallet_provider.dart';
import '../../wallet_screen/wallet_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        UpperCaseText(
          'Explore',
          style: Theme.of(context).textTheme.headline2!.copyWith(
                letterSpacing: 2,
                fontWeight: FontWeight.w300,
              ),
        ),

        const Spacer(),

        ///WALLET
        GestureDetector(
          onTap: () => Navigation.push(
            context,
            screen: const WalletScreen(),
          ),
          child: Row(
            children: [
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
              Hero(
                tag: 'wallet',
                child: SvgPicture.asset(
                  'assets/images/wallet.svg',
                  width: rf(32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
