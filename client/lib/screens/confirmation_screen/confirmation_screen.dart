import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/provider/collection_provider.dart';
import 'package:nfts/provider/wallet_provider.dart';
import 'package:nfts/screens/confirmation_screen/widgets/transaction_fee_widget.dart';
import 'package:nfts/screens/confirmation_screen/widgets/transaction_info.dart';
import 'package:nfts/screens/network_confirmation/network_confirmation_screen.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key, required this.onConfirmation})
      : super(key: key);

  // final String image;
  // final String
  final VoidCallback onConfirmation;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  //Confirm Transaction
  _confirmTransaction() {
    widget.onConfirmation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<WalletProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(),
                        SizedBox(height: rh(space4x)),

                        //NETWORK INFO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const _INFOTILE(
                              label: 'Network',
                              value: 'Polygon Testnet Mumbai',
                            ),
                            _INFOTILE(
                              //Confirm Transaction
                              label: 'Balance',
                              value: '${formatBalance(provider.balance)} MAT',
                            ),
                          ],
                        ),

                        SizedBox(height: rh(space4x)),
                        const Divider(),
                        SizedBox(height: rh(space4x)),

                        //FORM TO INFO
                        if (provider.transactionInfo != null)
                          TransactionInfo(
                            transactionInfo: provider.transactionInfo!,
                          ),

                        //FEE INFO
                        if (provider.state == WalletState.loading)
                          const Center(
                            child: EmptyWidget(text: 'Estimating gas fee ...'),
                          )
                        else
                          TransactionFeeWidget(
                            transactionInfo: provider.transactionInfo!,
                            gasInfo: provider.gasInfo!,
                            totalAmount: provider.totalAmount,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),

            //SLIDE TO CONFIRM
            Container(
              margin: const EdgeInsets.only(bottom: space6x),
              child:
                  Consumer<WalletProvider>(builder: (context, provider, child) {
                return ConfirmationSlider(
                  width: rw(300),
                  stickToEnd:
                      provider.state == WalletState.loading ? false : true,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: provider.state == WalletState.loading
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  text: 'SLIDE TO CONFIRM',
                  onConfirmation: provider.state == WalletState.loading
                      ? () {}
                      : _confirmTransaction,
                  shadow: BoxShadow(
                    blurRadius: 15,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _INFOTILE extends StatelessWidget {
  const _INFOTILE({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        UpperCaseText(
          label,
          // style: Theme.of(context).textTheme.overline,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(height: rh(6)),
        UpperCaseText(
          value,
          // style: Theme.of(context).textTheme.bodyText2,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
