import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../config/functions.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_placeholder/custom_placeholder.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/nft.dart';
import '../../provider/fav_provider.dart';
import '../../provider/nft_provider.dart';
import '../../provider/wallet_provider.dart';
import '../collection_screen/collection_screen.dart';
import '../confirmation_screen/confirmation_screen.dart';
import '../creator_screen/creator_screen.dart';
import '../modify_listing_screen/modify_listing_screen.dart';
import '../network_confirmation/network_confirmation_screen.dart';
import '../place_bid_screen/place_bid_screen.dart';
import 'widgets/activity_widget.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/contract_details_widget.dart';
import 'widgets/open_bid_widget.dart';
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

  _openBids(bool isOwner) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return OpenBidWidget(
          cancelBid: _cancelBid,
          isOwner: isOwner,
        );
      },
    );
  }

  _placeBid([double? highestBid]) {
    Navigation.push(
      context,
      screen: PlaceBidScreen(
        nft: widget.nft,
        highestBid: highestBid,
      ),
    );
  }

  _cancelBid() {
    final provider = Provider.of<WalletProvider>(context, listen: false);

    provider.buildTransaction(
      widget.nft.cAddress,
      fcancelBid,
      [BigInt.from(widget.nft.tokenId)],
    );

    Navigation.push(
      context,
      screen: ConfirmationScreen(
        action: 'Cancel Bid',
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
  }

  _sellBid(NFTProvider nftProvider) {
    final provider = Provider.of<WalletProvider>(context, listen: false);

    provider.buildTransaction(
      widget.nft.cAddress,
      fsellBiddingNFT,
      [
        BigInt.from(widget.nft.tokenId),
        EthereumAddress.fromHex(
          nftProvider.selectedBid!.from,
        )
      ],
    );

    Navigation.push(
      context,
      screen: ConfirmationScreen(
        action: 'Sell NFT',
        image: widget.nft.image,
        title: widget.nft.name,
        subtitle: 'Selling to ${formatAddress(nftProvider.selectedBid!.from)}',
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

  //Navigate to modify listing
  _modifyListing() {
    Navigation.push(
      context,
      screen: ModifyListingScreen(nft: widget.nft),
    );
  }

  _buyNFT(double price) {
    final provider = Provider.of<WalletProvider>(context, listen: false);

    provider.buildTransaction(
      widget.nft.cAddress,
      fbuyFixedPriceNFT,
      [
        BigInt.from(widget.nft.tokenId),
      ],
      price,
    );

    Navigation.push(
      context,
      screen: ConfirmationScreen(
        action: 'Buy NFT',
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
      body: Column(
        children: [
          //SCROLLABLE PART
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: space2x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      actions: [
                        Buttons.icon(
                          context: context,
                          icon: Iconsax.share,
                          left: rw(space2x),
                          top: 0,
                          bottom: 0,
                          semanticLabel: 'Share',
                          onPressed: () => share(
                            widget.nft.name + ' NFT',
                            widget.nft.image,
                            widget.nft.cName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rh(space2x)),

                    //IMAGE
                    Hero(
                      tag: '${widget.nft.cAddress}-${widget.nft.tokenId}',
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
                        Consumer<FavProvider>(
                            builder: (context, favProvider, child) {
                          return Buttons.icon(
                            context: context,
                            icon: favProvider.isFavNFT(widget.nft)
                                ? Iconsax.heart5
                                : Iconsax.heart,
                            size: rf(20),
                            semanticLabel: 'Heart',
                            onPressed: () => favProvider.setFavNFT(widget.nft),
                          );
                        })
                      ],
                    ),
                    SizedBox(height: rh(space2x)),
                    Consumer<NFTProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.metadata.description,
                          style: Theme.of(context).textTheme.caption,
                        );
                      },
                    ),
                    SizedBox(height: rh(space3x)),

                    //OWNER INFO
                    Row(
                      children: [
                        Expanded(
                          child: Consumer<NFTProvider>(
                              builder: (context, provider, child) {
                            return DataInfoChip(
                              image: widget.nft.cImage,
                              label: 'From collection',
                              value: widget.nft.cName,
                              onTap: provider.state == NFTState.loading
                                  ? () {}
                                  : () => Navigation.push(
                                        context,
                                        screen: CollectionScreen(
                                          collection: provider.nftCollection!,
                                        ),
                                      ),
                              // 'The minimalist',
                            );
                          }),
                        ),
                        Expanded(
                          child: DataInfoChip(
                            image:
                                'QmWTq1mVjiBp6kPXeT2XZftvsWQ6nZwSBvTbqKLumipMwD',
                            label: 'Owned by',
                            value: formatAddress(widget.nft.owner),
                            onTap: () {
                              Navigation.push(
                                context,
                                screen: CreatorScreen(owner: widget.nft.owner),
                              );
                            },
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
          ),

          //FIXED PART
          Consumer<WalletProvider>(builder: (context, walletProvider, child) {
            return Consumer<NFTProvider>(
                builder: (context, nftProvider, child) {
              if (nftProvider.listingInfo == null) {
                return const BottomBar(
                  label: "Price",
                  price: '',
                  buttonText: 'Buy NFT',
                  onlyText: 'Loading...',
                );
              }

              final _isOwner = widget.nft.owner == walletProvider.address.hex;
              final _listingType = nftProvider.listingInfo!.listingType;
              final _listingInfo = nftProvider.listingInfo!;

              final _bids = nftProvider.bids;

              if (_isOwner) {
                //BIDDING
                if (_listingType == ListingType.bidding) {
                  if (_bids.isEmpty) {
                    return BottomBar(
                      label: 'Minimum Bid',
                      price: '${_listingInfo.price} MAT',
                      buttonText: '',
                      // onIconPressed: () => _openBids(_isOwner),
                      // onButtonPressed: _sellBid,
                    );
                  } else {
                    return BottomBar(
                      label:
                          'From ${formatAddress(nftProvider.selectedBid!.from)}',
                      price: '${nftProvider.selectedBid!.price} MAT',
                      buttonText: 'Sell Bid',
                      icon: Iconsax.arrow_up_2,
                      onIconPressed: () => _openBids(_isOwner),
                      onButtonPressed: () => _sellBid(nftProvider),
                    );
                  }
                }

                //Fixed price for sale
                else if (_listingType == ListingType.fixedPriceSale) {
                  return BottomBar(
                    label: "For Sale",
                    price: '${_listingInfo.price} MAT',
                    buttonText: 'Modify Listing',
                    onButtonPressed: _modifyListing,
                  );
                }

                //Fixed price Not for sale
                else if (_listingType == ListingType.fixedPriceNotSale) {
                  return BottomBar(
                    label: "Not For Sale",
                    price: '',
                    buttonText: 'Modify Listing',
                    onButtonPressed: _modifyListing,
                  );
                }
              } else {
                //Bidding
                if (_listingType == ListingType.bidding) {
                  if (_bids.isEmpty) {
                    return BottomBar(
                      label: 'Minimum Bid',
                      price: '${_listingInfo.price} MAT',
                      buttonText: 'Place Bid',
                      onButtonPressed: () => _placeBid(),
                    );
                  }

                  //BIDS IS NOT EMPTY
                  else {
                    final hasUserBid = _bids.indexWhere(
                            (bid) => bid.from == walletProvider.address.hex) !=
                        -1;

                    return BottomBar(
                      label: 'Highest Bid',
                      price: '${_bids[0].price} MAT',
                      buttonText: hasUserBid ? 'Cancel Bid' : 'Place Bid',
                      icon: Iconsax.arrow_up_2,
                      onIconPressed: () => _openBids(_isOwner),
                      onButtonPressed: () =>
                          hasUserBid ? _cancelBid() : _placeBid(_bids[0].price),
                    );
                  }
                }

                //Fixed Price for sale
                else if (_listingType == ListingType.fixedPriceSale) {
                  return BottomBar(
                    label: "Price",
                    price: '${_listingInfo.price} MAT',
                    buttonText: 'Buy NFT',
                    onButtonPressed: () => _buyNFT(_listingInfo.price),
                  );
                }

                //Fixed Price not for sale
                else if (_listingType == ListingType.fixedPriceNotSale) {
                  return BottomBar(
                    label: "Price",
                    price: '${_listingInfo.price} MAT',
                    buttonText: '',
                    onlyText: 'Not For Sale',
                  );
                }
              }

              return const BottomBar(
                label: 'Error',
                price: 'Somthing went wrong',
                buttonText: '',
                onlyText: 'Something went wrong',
              );
            });
          }),
        ],
      ),
    );
  }
}
