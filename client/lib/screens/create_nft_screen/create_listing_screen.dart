import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nfts/core/animations/animations.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/models/collection.dart';
import 'package:nfts/models/listing_info.dart';
import 'package:nfts/models/nft_metadata.dart';
import 'package:nfts/provider/nft_provider.dart';
import 'package:nfts/provider/wallet_provider.dart';
import 'package:nfts/screens/confirmation_screen/confirmation_screen.dart';
import 'package:nfts/screens/create_nft_screen/widgets/selectable_container.dart';
import 'package:nfts/screens/network_confirmation/network_confirmation_screen.dart';
import 'package:provider/provider.dart';

class CreateNFTListingScreen extends StatefulWidget {
  const CreateNFTListingScreen({
    Key? key,
    required this.nftMetadata,
    required this.collection,
  }) : super(key: key);

  final NFTMetadata nftMetadata;
  final Collection collection;

  @override
  _CreateNFTListingScreenState createState() => _CreateNFTListingScreenState();
}

class _CreateNFTListingScreenState extends State<CreateNFTListingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _royaltiesController = TextEditingController();

  _mintNFT() async {
    final provider = Provider.of<NFTProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      final listing = ListingInfo(
        listingType: provider.listingType,
        price: double.parse(_priceController.text),
        royalties: double.parse(_royaltiesController.text),
      );
      // provider.mintNFT(listing);
      final transaction =
          await provider.buildTransaction(listing, widget.collection);

      Provider.of<WalletProvider>(context, listen: false)
          .getTransactionFee(transaction);

      Navigation.push(
        context,
        screen: ConfirmationScreen(onConfirmation: () {
          provider.mintNFT(listing, widget.collection);
          Navigation.popTillNamedAndPush(
            context,
            popTill: 'tabs_screen',
            screen: const NetworkConfirmationScreen(),
          );
        }),
      );
    }
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

              _NFTListTile(
                imagePath: widget.nftMetadata.image,
                title: widget.nftMetadata.name,
                subtitle: widget.collection.name,
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
                FadeAnimation(
                  child: Row(
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
                ),

              if (_listingType != ListingType.bidding)
                SizedBox(height: rh(space3x)),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextFormField(
                      controller: _royaltiesController,
                      labelText: 'ROYALTIES %',
                      validator: validator,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: rh(space2x)),
                    CustomTextFormField(
                      controller: _priceController,
                      labelText: _listingType == ListingType.bidding
                          ? 'MINIMUM BID PRICE IN MAT'
                          : 'FIXED PRICE IN MAT',
                      validator: validator,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),

              SizedBox(height: rh(space4x)),

              Buttons.flexible(
                width: double.infinity,
                context: context,
                text: 'Mint NFT',
                onPressed: _mintNFT,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _NFTListTile extends StatelessWidget {
  const _NFTListTile({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(space1x),
          child: Image.file(
            File(imagePath),
            width: rf(56),
            height: rf(56),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: rw(space2x)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VerifiedText(
                text: title,
                isVerified: false,
              ),
              SizedBox(height: rh(4)),
              VerifiedText(
                text: subtitle,
                isUpperCase: false,
                isVerified: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
