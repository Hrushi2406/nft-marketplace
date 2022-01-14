import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/functions.dart';
import '../../core/animations/fade_animation.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/nft.dart';
import '../../provider/nft_provider.dart';
import '../../provider/wallet_provider.dart';
import '../confirmation_screen/confirmation_screen.dart';
import '../create_nft_screen/widgets/selectable_container.dart';
import '../network_confirmation/network_confirmation_screen.dart';

class ModifyListingScreen extends StatefulWidget {
  const ModifyListingScreen({Key? key, required this.nft}) : super(key: key);

  final NFT nft;

  @override
  _ModifyListingScreenState createState() => _ModifyListingScreenState();
}

class _ModifyListingScreenState extends State<ModifyListingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController = TextEditingController();

  _modifyListing() {
    final provider = Provider.of<WalletProvider>(context, listen: false);
    final nftProvider = Provider.of<NFTProvider>(context, listen: false);

    final isFixedPrice = (nftProvider.listingType != ListingType.bidding);

    final isForSale = nftProvider.listingType == ListingType.fixedPriceSale;

    final newPrice = double.parse(
          _priceController.text.isEmpty ? '0' : _priceController.text,
        ) *
        pow(10, 18);

    provider.buildTransaction(
      widget.nft.cAddress,
      fmodifyListingMechanism,
      [
        BigInt.from(widget.nft.tokenId),
        isFixedPrice,
        isForSale,
        BigInt.from(newPrice)
      ],
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
          // Provider.of<NFTProvider>(context, listen: false)
          // .fetchNFTMetadata(widget.nft);
          Navigation.popTillNamedAndPush(
            context,
            popTill: 'tabs_screen',
            screen: const NetworkConfirmationScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Consumer<NFTProvider>(builder: (context, provider, child) {
          final _listingType = provider.listingType;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              SizedBox(height: rh(space3x)),

              CollectionListTile(
                image: widget.nft.image,
                title: widget.nft.name,
                subtitle: widget.nft.cName,
                showFav: false,
              ),
              SizedBox(height: rh(space4x)),
              Row(
                children: [
                  Expanded(
                    child: SelectableContainer(
                      isSelected: _listingType == ListingType.fixedPriceSale ||
                          _listingType == ListingType.fixedPriceNotSale,
                      text: 'Fixed Price',
                      onPressed: () =>
                          provider.listingType = (ListingType.fixedPriceSale),
                    ),
                  ),
                  SizedBox(width: rw(space2x)),
                  Expanded(
                    child: SelectableContainer(
                      isSelected: _listingType == ListingType.bidding,
                      text: 'Open for bid',
                      onPressed: () =>
                          provider.listingType = (ListingType.bidding),
                    ),
                  ),
                ],
              ),
              SizedBox(height: rh(space3x)),

              //DYNAMIC CONTENT

              if (_listingType != ListingType.bidding)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UpperCaseText(
                      'For Sale',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    CupertinoSwitch(
                      value: _listingType == ListingType.fixedPriceSale,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) => provider.listingType = (value
                          ? ListingType.fixedPriceSale
                          : ListingType.fixedPriceNotSale),
                    ),
                  ],
                ),

              if (_listingType != ListingType.bidding)
                SizedBox(height: rh(space3x)),

              if (_listingType != ListingType.fixedPriceNotSale)
                FadeAnimation(
                  child: Form(
                    key: _formKey,
                    child: CustomTextFormField(
                      controller: _priceController,
                      labelText: _listingType == ListingType.bidding
                          ? 'Minimum bid price in MAT '
                          : 'Fixed Price in MAT',
                      validator: validator,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),

              if (_listingType != ListingType.fixedPriceNotSale)
                SizedBox(height: rh(space4x)),

              Buttons.flexible(
                width: double.infinity,
                context: context,
                text: 'Modify Listing',
                onPressed: _modifyListing,
              ),
            ],
          );
        }),
      ),
    );
  }
}
