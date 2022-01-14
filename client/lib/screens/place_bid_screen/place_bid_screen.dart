import 'package:flutter/material.dart';
import '../../config/functions.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/nft.dart';
import '../../provider/wallet_provider.dart';
import '../confirmation_screen/confirmation_screen.dart';
import '../network_confirmation/network_confirmation_screen.dart';
import 'package:provider/provider.dart';

class PlaceBidScreen extends StatefulWidget {
  const PlaceBidScreen({
    Key? key,
    required this.nft,
    this.highestBid,
  }) : super(key: key);

  final NFT nft;
  final double? highestBid;

  @override
  _PlaceBidScreenState createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bidPriceController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<WalletProvider>(context, listen: false).getBalance();
  }

  _placeBid() {
    //TODO: Validate Current bid should be more than minimum bid
    final provider = Provider.of<WalletProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      provider.buildTransaction(
        widget.nft.cAddress,
        fplaceBid,
        [BigInt.from(widget.nft.tokenId)],
        double.parse(_bidPriceController.text),
      );

      Navigation.push(
        context,
        screen: ConfirmationScreen(
          action: 'Place Bid',
          image: widget.nft.image,
          title: widget.nft.name,
          subtitle: widget.nft.cName,
          isAutoMated: true,
          onConfirmation: () {
            Navigation.popTillNamedAndPush(
              context,
              popTill: 'tabs_screen',
              screen: const NetworkConfirmationScreen(),
            );
          },
        ),
      );

      // NFT
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CustomAppBar(),
            SizedBox(height: rh(space3x)),
            //Image
            CollectionListTile(
              image: widget.nft.image,
              title: widget.nft.name,
              subtitle: widget.nft.cName,
              showFav: false,
            ),

            if (widget.highestBid != null) SizedBox(height: rh(space4x)),

            if (widget.highestBid != null)
              BidTile(
                text: 'Current Highest Bid',
                value: '${widget.highestBid} MAT',
              ),

            SizedBox(height: rh(space3x)),
            const Divider(),
            SizedBox(height: rh(space3x)),

            Center(
              child: UpperCaseText(
                'Platform suggests 10% higher bid ',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: rh(space3x)),

            Form(
              key: _formKey,
              child: CustomTextFormField(
                controller: _bidPriceController,
                labelText: 'BIDDING PRICE',
                validator: validator,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: rh(space2x)),

            Consumer<WalletProvider>(builder: (context, provider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UpperCaseText(
                    'Balance - ${formatBalance(provider.balance)} MAT',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              );
            }),

            SizedBox(height: rh(space4x)),

            Buttons.flexible(
              width: double.infinity,
              context: context,
              text: 'Place Bid',
              onPressed: _placeBid,
            ),
          ],
        ),
      ),
    );
  }
}
