import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nfts/core/widgets/custom_placeholder/custom_placeholder.dart';
import 'package:nfts/provider/nft_provider.dart';
import 'package:nfts/screens/nft_screen/widgets/contract_details_widget.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/nft.dart';
import 'widgets/activity_widget.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/properties_widget.dart';

class NFTScreen extends StatefulWidget {
  const NFTScreen({Key? key, required this.nft}) : super(key: key);

  final NFT nft;

  @override
  _NFTScreenState createState() => _NFTScreenState();
}

class _NFTScreenState extends State<NFTScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<NFTProvider>(context, listen: false)
        .fetchNFTMetadata(widget.nft);
  }

  _openBids() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: space2x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: rh(space3x)),
              //MY BID
              UpperCaseText(
                'My Bids',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: rh(space2x)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UpperCaseText(
                    '8.5 ETH',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Buttons.text(
                    context: context,
                    right: 0,
                    text: 'Cancel',
                    onPressed: () {},
                  ),
                ],
              ),

              SizedBox(height: rh(space2x)),
              const Divider(),
              SizedBox(height: rh(space2x)),

              //OTHER BIDS
              UpperCaseText(
                'Bids',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: rh(space2x)),

              const BidTile(text: 'Hrushikesh Kuklare', value: '10.5 ETH'),
              SizedBox(height: rh(space2x)),
              const BidTile(
                text: 'Hrushikesh Kuklare',
                value: '10.5 ETH',
                isSelected: true,
              ),
              SizedBox(height: rh(space2x)),
              const BidTile(text: 'Hrushikesh Kuklare', value: '10.5 ETH'),
              SizedBox(height: rh(space2x)),
              const BidTile(text: 'Hrushikesh Kuklare', value: '10.5 ETH'),

              const Spacer(),

              //Bottom Bar
              BottomBar(
                label: 'Highest Bid',
                price: '10 MAT',
                buttonText: 'Place Bid',
                icon: Iconsax.arrow_down_1,
                onTap: () => Navigation.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          children: [
            //SCROLLABLE PART
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(),
                    SizedBox(height: rh(space2x)),

                    //IMAGE
                    Hero(
                      tag: widget.nft.image,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(space1x),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://ipfs.io/ipfs/${widget.nft.image}',
                            fit: BoxFit.cover,
                            placeholder: (_, url) => const CustomPlaceHolder(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: rh(space2x)),

                    //TITLE & DESCRIPTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UpperCaseText(
                          widget.nft.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Buttons.icon(
                          context: context,
                          icon: Iconsax.heart,
                          size: rf(18),
                          semanticLabel: 'Heart',
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(height: rh(space3x)),
                    Text(
                      'Minimalism is all about owning only what adds value and meaning to your life and removing the rest.',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: rh(space3x)),

                    //OWNER INFO
                    Row(
                      children: [
                        Expanded(
                          child: DataInfoChip(
                            image: 'assets/images/collection-2.png',
                            // image: widget.nft
                            label: 'From collection',
                            value: widget.nft.collectionName,
                            // 'The minimalist',
                          ),
                        ),
                        Expanded(
                          child: DataInfoChip(
                            image: 'assets/images/collection-3.png',
                            label: 'Owned by',
                            value: formatAddress(widget.nft.owner),
                            // 'The minimalist',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: rh(space2x)),
                    const Divider(),
                    SizedBox(height: rh(space2x)),

                    //PROPERTIES
                    const PropertiesWidget(),

                    //ACTIVITY
                    const ActivityWidget(),

                    //CONTRACT DETAILS
                    ContractDetailsWidget(nft: widget.nft),

                    SizedBox(height: rh(space6x)),
                  ],
                ),
              ),
            ),

            //FIXED PART
            BottomBar(
              label: 'Highest Bid',
              price: '10 MAT',
              buttonText: 'Place Bid',
              icon: Iconsax.arrow_up_2,
              onTap: _openBids,
            )
          ],
        ),
      ),
    );
  }
}
