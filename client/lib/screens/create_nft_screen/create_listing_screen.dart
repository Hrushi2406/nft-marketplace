import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nfts/core/animations/animations.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/models/collection.dart';
import 'package:nfts/models/nft_metadata.dart';
import 'package:nfts/screens/create_nft_screen/widgets/selectable_container.dart';

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
  ListingType _lisitingType = ListingType.fixedPriceSale;
  final TextEditingController _textController = TextEditingController();

  _changeListingType(ListingType type) {
    _lisitingType = type;
    setState(() {});
  }

  _mintNFT() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
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
                    isSelected: _lisitingType == ListingType.fixedPriceSale ||
                        _lisitingType == ListingType.fixedPriceNotSale,
                    text: 'Fixed Price',
                    onPressed: () =>
                        _changeListingType(ListingType.fixedPriceSale),
                  ),
                ),
                SizedBox(width: rw(space2x)),
                Expanded(
                  child: SelectableContainer(
                    isSelected: _lisitingType == ListingType.bidding,
                    text: 'Open for bid',
                    onPressed: () => _changeListingType(ListingType.bidding),
                  ),
                ),
              ],
            ),
            SizedBox(height: rh(space3x)),

            //DYNAMIC CONTENT

            if (_lisitingType != ListingType.bidding)
              FadeAnimation(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UpperCaseText(
                      'For Sale',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    CupertinoSwitch(
                      value: _lisitingType == ListingType.fixedPriceSale,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) => _changeListingType(
                        value
                            ? ListingType.fixedPriceSale
                            : ListingType.fixedPriceNotSale,
                      ),
                    ),
                  ],
                ),
              ),

            if (_lisitingType != ListingType.bidding)
              SizedBox(height: rh(space3x)),

            CustomTextFormField(
              controller: _textController,
              labelText: _lisitingType == ListingType.bidding
                  ? 'MINIMUM BID PRICE IN MAT'
                  : 'FIXED PRICE IN MAT',
              validator: validator,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),

            SizedBox(height: rh(space4x)),

            Buttons.flexible(
              width: double.infinity,
              context: context,
              text: 'Mint NFT',
              onPressed: _mintNFT,
            ),
          ],
        ),
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
