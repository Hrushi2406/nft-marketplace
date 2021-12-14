import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/animations.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_placeholder/custom_placeholder.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/collection.dart';
import '../../provider/collection_provider.dart';
import '../../provider/fav_provider.dart';
import '../../provider/wallet_provider.dart';
import '../create_nft_screen/create_nft_screen.dart';
import '../nft_screen/nft_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key, required this.collection})
      : super(key: key);

  final Collection collection;

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<CollectionProvider>(context, listen: false)
        .fetchCollectionMeta(widget.collection);
  }

  _openUrl(String url) async {
    if (!await launch(url)) {}
  }

  _createNFT() {
    Navigation.push(
      context,
      screen: CreateNFTScreen(collection: widget.collection),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),

              SizedBox(height: rh(space2x)),

              //LIST TILE
              Consumer<FavProvider>(builder: (context, favProvider, child) {
                return CollectionListTile(
                  image: widget.collection.image,
                  title: widget.collection.name,
                  subtitle: 'By ' + formatAddress(widget.collection.creator),
                  isFav: favProvider.isFavCollection(widget.collection),
                  onFavPressed: () =>
                      favProvider.setFavCollection(widget.collection),
                );
              }),
              SizedBox(height: rh(space3x)),

              //DESCRIPTION
              Consumer<CollectionProvider>(
                builder: (context, provider, child) {
                  return Text(
                    provider.metaData.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // 'UnknownCulturz is a unique limited series of 25 artworks which tells a story in the metaverse.',
                    style: Theme.of(context).textTheme.caption,
                  );
                },
              ),
              SizedBox(height: rh(space3x)),

              //INSIGHTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpperCaseText(
                    // '25 Items',
                    ' ${widget.collection.nItems} Items',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  UpperCaseText(
                    '|',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Consumer<CollectionProvider>(
                      builder: (context, provider, child) {
                    return UpperCaseText(
                      '${provider.distinctOwners.length} Owners',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  }),
                  UpperCaseText(
                    '|',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  UpperCaseText(
                    '${widget.collection.volumeOfEth} MAT Vol',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              SizedBox(height: rh(space3x)),

              //LINKS
              Consumer<CollectionProvider>(
                builder: (context, provider, child) {
                  final metaData = provider.metaData;
                  return Row(
                    children: <Widget>[
                      if (metaData.twitterUrl.isNotEmpty)
                        SlideAnimation(
                          begin: const Offset(-60, 0),
                          child: Buttons.icon(
                            context: context,
                            svgPath: 'assets/images/twitter.svg',
                            right: rw(space2x),
                            semanticLabel: 'twitter',
                            onPressed: () => _openUrl(metaData.twitterUrl),
                          ),
                        ),
                      if (metaData.websiteUrl.isNotEmpty)
                        SlideAnimation(
                          begin: const Offset(-40, 0),
                          child: Buttons.icon(
                            context: context,
                            icon: Iconsax.global5,
                            right: rw(space2x),
                            semanticLabel: 'Website',
                            onPressed: () => _openUrl(metaData.websiteUrl),
                          ),
                        ),
                      Buttons.icon(
                        context: context,
                        icon: Iconsax.copy,
                        right: rw(space2x),
                        semanticLabel: 'Copy',
                        onPressed: () => copy(widget.collection.cAddress),
                      ),
                      Buttons.icon(
                        context: context,
                        icon: Iconsax.share,
                        right: rw(space2x),
                        top: 0,
                        bottom: 0,
                        semanticLabel: 'Share',
                        onPressed: () => share(
                          widget.collection.name + " collection",
                          widget.collection.image,
                          metaData.description,
                        ),
                      ),
                      const Spacer(),
                      Consumer<WalletProvider>(
                          builder: (context, walletProvider, child) {
                        // print(widget.collection.creator);
                        if (walletProvider.address.hex ==
                            widget.collection.creator) {
                          return Buttons.text(
                            context: context,
                            right: 0,
                            text: 'Create NFT',
                            onPressed: _createNFT,
                          );
                        }
                        return Container();
                      }),
                    ],
                  );
                },
              ),

              SizedBox(height: rh(space3x)),
              const Divider(),
              SizedBox(height: rh(space3x)),

              //ITEMS
              UpperCaseText(
                'Items',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: rh(space3x)),

              Consumer<CollectionProvider>(builder: (context, provider, child) {
                if (provider.state == CollectionState.loading) {
                  return const LoadingIndicator();
                } else if (provider.state == CollectionState.empty) {
                  return const EmptyWidget(text: 'No Items ');
                }
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: rh(space2x),
                    crossAxisSpacing: rw(space2x),
                  ),
                  itemCount: provider.collectionItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final nft = provider.collectionItems[index];
                    return GestureDetector(
                      onTap: () =>
                          Navigation.push(context, screen: NFTScreen(nft: nft)),
                      child: Hero(
                        tag: '${nft.cAddress}-${nft.tokenId}',
                        child: _ItemsTile(
                          image: nft.image,
                          title: nft.name,
                          // 'Stuck in time',
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemsTile extends StatelessWidget {
  const _ItemsTile({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //BACKGROUND IMAGE
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(space1x),
            child: CachedNetworkImage(
              imageUrl: 'https://ipfs.io/ipfs/$image',
              fit: BoxFit.cover,
              placeholder: (_, url) => CustomPlaceHolder(size: rw(56)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        //OverLay
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: rh(60),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(
              bottom: space2x,
              left: space1x,
              right: space1x,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(space1x),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
            child: UpperCaseText(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
