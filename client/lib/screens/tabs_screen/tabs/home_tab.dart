import 'package:flutter/material.dart';
import '../../../provider/fav_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/app_provider.dart';
import '../../collection_screen/collection_screen.dart';
import '../../nft_screen/nft_screen.dart';
import '../widgets/home_app_bar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: rh(70)),
            //APPBAR
            const HomeAppBar(),
            SizedBox(height: rh(space4x)),

            //TOP COLLECTIONS
            UpperCaseText(
              'Top Collections',
              style: Theme.of(context).textTheme.headline4,
            ),

            SizedBox(height: rh(space3x)),

            Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.state == AppState.loading) {
                  return const LoadingIndicator();
                }

                return Consumer<FavProvider>(
                    builder: (context, favProvider, child) {
                  return ListView.separated(
                    itemCount: provider.topCollections.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space2x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final collection = provider.topCollections[index];
                      return GestureDetector(
                        onTap: () => Navigation.push(
                          context,
                          screen: CollectionScreen(collection: collection),
                        ),
                        child: CollectionListTile(
                          image: collection.image,
                          title: collection.name,
                          subtitle: 'By ${formatAddress(collection.creator)}',
                          isFav: favProvider.isFavCollection(collection),
                          onFavPressed: () =>
                              favProvider.setFavCollection(collection),
                        ),
                      );
                    },
                  );
                });
              },
            ),
            // ListView.separated(
            //   itemCount: 3,
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   separatorBuilder: (BuildContext context, int index) {
            //     return SizedBox(height: rh(space2x));
            //   },
            //   itemBuilder: (BuildContext context, int index) {
            //     return GestureDetector(
            //       onTap: () => Navigation.push(
            //         context,
            //         screen: const CollectionScreen(),
            //       ),
            //       child: CollectionListTile(
            //         image: 'assets/images/collection-${index + 1}.png',
            //         title: 'Less is More',
            //         subtitle: 'By The Minimalist',
            //       ),
            //     );
            //   },
            // ),

            SizedBox(height: rh(space3x)),
            const Divider(),
            SizedBox(height: rh(space3x)),

            //FEATURED NFTS
            UpperCaseText(
              'Featured NFTS',
              style: Theme.of(context).textTheme.headline4,
            ),

            SizedBox(height: rh(space3x)),

            Consumer<AppProvider>(
              builder: (context, provider, child) {
                return Consumer<FavProvider>(
                    builder: (context, favProvider, child) {
                  return ListView.separated(
                    itemCount: provider.featuredNFTs.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space3x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final nft = provider.featuredNFTs[index];

                      return NFTCard(
                        onTap: () => Navigation.push(context,
                            screen: NFTScreen(nft: nft)),
                        heroTag: '${nft.cAddress}-${nft.tokenId}',
                        image: nft.image,
                        title: nft.name,
                        subtitle: nft.cName,
                        isFav: favProvider.isFavNFT(nft),
                        onFavPressed: () => favProvider.setFavNFT(nft),
                      );
                    },
                  );
                });
              },
            ),

            // ListView.separated(
            //   itemCount: 3,
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   separatorBuilder: (BuildContext context, int index) {
            //     return SizedBox(height: rh(space3x));
            //   },
            //   itemBuilder: (BuildContext context, int index) {
            //     return NFTCard(
            //       onTap: () =>
            //           Navigation.push(context, screen: const NFTScreen()),
            //       heroTag: '$index',
            //       image: 'assets/images/nft-${index + 1}.png',
            //       title: 'Woven Into Fabric',
            //       subtitle: 'Fabric Cloths',
            //     );
            //   },
            // ),

            SizedBox(height: rh(space3x)),
          ],
        ),
      ),
    );
  }
}
