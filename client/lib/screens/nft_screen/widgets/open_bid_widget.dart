import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/nft_provider.dart';
import '../../../provider/wallet_provider.dart';

class OpenBidWidget extends StatefulWidget {
  const OpenBidWidget(
      {Key? key, required this.cancelBid, required this.isOwner})
      : super(key: key);

  final VoidCallback cancelBid;
  final bool isOwner;

  @override
  _OpenBidWidgetState createState() => _OpenBidWidgetState();
}

class _OpenBidWidgetState extends State<OpenBidWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: space2x),
      child:
          Consumer<WalletProvider>(builder: (context, walletProvider, child) {
        return Consumer<NFTProvider>(builder: (context, nftProvider, child) {
          final userBidIndex = nftProvider.bids
              .indexWhere((bid) => bid.from == walletProvider.address.hex);

          final hasUserBid = userBidIndex != -1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: rh(space3x)),
              //MY BID
              if (hasUserBid)
                UpperCaseText(
                  'My Bids',
                  style: Theme.of(context).textTheme.headline3,
                ),
              if (hasUserBid) SizedBox(height: rh(space2x)),

              if (hasUserBid)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UpperCaseText(
                      '${nftProvider.bids[userBidIndex].price} MAT',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Buttons.text(
                      context: context,
                      right: 0,
                      text: 'Cancel',
                      onPressed: widget.cancelBid,
                    ),
                  ],
                ),

              if (hasUserBid) SizedBox(height: rh(space2x)),
              if (hasUserBid) const Divider(),
              if (hasUserBid) SizedBox(height: rh(space2x)),

              //OTHER BIDS
              UpperCaseText(
                'Bids',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: rh(space2x)),

              Expanded(
                child: ListView.separated(
                  itemCount: nftProvider.bids.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: rh(space2x));
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final bid = nftProvider.bids[index];

                    return GestureDetector(
                      onTap: () async {
                        nftProvider.selectedBid = bid;
                        await Future.delayed(const Duration(milliseconds: 250));
                        Navigation.pop(context);
                      },
                      child: BidTile(
                        text: formatAddress(bid.from),
                        value: '${bid.price} MAT',
                        isSelected: widget.isOwner
                            ? nftProvider.selectedBid == bid
                            : false,
                      ),
                    );
                  },
                ),
              ),

              //Bottom Bar
              // BottomBar(
              //   label: 'Highest Bid',
              //   price: '10 MAT',
              //   buttonText: 'Place Bid',
              //   icon: Iconsax.arrow_down_1,
              //   onButtonPressed: () => Navigation.pop(context),
              // )
            ],
          );
        });
      }),
    );
  }
}
