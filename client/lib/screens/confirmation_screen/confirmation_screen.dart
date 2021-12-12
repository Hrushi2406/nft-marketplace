import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/wallet_provider.dart';
import 'widgets/transaction_fee_widget.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    Key? key,
    this.onConfirmation,
    this.isAutoMated = false,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.action,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;
  final String action;

  final bool isAutoMated;
  final VoidCallback? onConfirmation;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  //Confirm Transaction
  _confirmTransaction() async {
    if (widget.isAutoMated) {
      final provider = Provider.of<WalletProvider>(context, listen: false);

      provider.sendTransaction(provider.transactionInfo!);
    }

    if (widget.onConfirmation != null) widget.onConfirmation!();
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
                        CustomAppBar(title: widget.action),
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

                        SizedBox(height: rh(space2x)),
                        const Divider(),
                        SizedBox(height: rh(space2x)),

                        // Center(
                        //   child: UpperCaseText(
                        //     widget.action,
                        //     style:
                        //         Theme.of(context).textTheme.headline6!.copyWith(
                        //               letterSpacing: 2.5,
                        //             ),
                        //   ),
                        // ),
                        // SizedBox(height: rh(18)),

                        //Input
                        CollectionListTile(
                          image: widget.image,
                          title: widget.title,
                          subtitle: widget.subtitle,
                          // subtitle: widget.action,
                          isSubtitleVerified: true,
                          showFav: false,
                        ),

                        SizedBox(height: rh(space3x)),
                        const Divider(),
                        SizedBox(height: rh(space3x)),

                        //FORM TO INFO
                        // if (provider.transactionInfo != null)
                        //   TransactionInfo(
                        //     transactionInfo: provider.transactionInfo!,
                        //   ),

                        //FEE INFO
                        if (provider.state == WalletState.loading)
                          const Center(
                            child: EmptyWidget(text: 'Estimating gas fee ...'),
                          )
                        else if (provider.state == WalletState.error)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: space2x,
                              vertical: space2x,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).errorColor,
                            ),
                            child: UpperCaseText(
                              provider.errMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.white,
                                    height: 1.8,
                                  ),
                            ),
                          )
                        else
                          TransactionFeeWidget(
                            transactionInfo: provider.transactionInfo!,
                            gasInfo: provider.gasInfo!,
                            totalAmount: provider.totalAmount,
                            maticPrice: provider.maticPrice,
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
                  foregroundColor: provider.state == WalletState.loading ||
                          provider.state == WalletState.error
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  text: provider.state == WalletState.error
                      ? 'Error Occured'
                      : 'SLIDE TO CONFIRM',
                  onConfirmation: provider.state == WalletState.loading ||
                          provider.state == WalletState.error
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
