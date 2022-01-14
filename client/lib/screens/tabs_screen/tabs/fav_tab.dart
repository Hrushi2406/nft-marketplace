import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/fav_provider.dart';
import '../../collection_screen/collection_screen.dart';
import '../../nft_screen/nft_screen.dart';

class FavTab extends StatelessWidget {
  const FavTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: rh(60)),
        Expanded(
          child: Consumer<FavProvider>(builder: (context, favProvider, child) {
            return CustomTabBar(
              titles: const ['Collections', 'NFTS'],
              tabs: [
                if (favProvider.favCollections.isEmpty)
                  const EmptyWidget(
                    text: 'No Favorite collections',
                  )
                else

                  //COLLECTION VIEW
                  ListView.separated(
                    itemCount: favProvider.favCollections.length,
                    padding: const EdgeInsets.only(
                      left: space2x,
                      right: space2x,
                      bottom: space3x,
                      top: space4x,
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space2x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final collection = favProvider.favCollections[index];
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
                  ),
                if (favProvider.favNFT.isEmpty)
                  const EmptyWidget(text: 'No Favorite NFTs')
                else
                  //NFT VIEW
                  ListView.separated(
                    itemCount: favProvider.favNFT.length,
                    padding: const EdgeInsets.only(
                      left: space2x,
                      right: space2x,
                      bottom: space3x,
                      top: space3x,
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space3x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final nft = favProvider.favNFT[index];
                      return NFTCard(
                        onTap: () => Navigation.push(
                          context,
                          screen: NFTScreen(nft: nft),
                        ),
                        heroTag: '${nft.cAddress}-${nft.tokenId}',
                        image: nft.image,
                        title: nft.name,
                        subtitle: nft.cName,
                        isFav: favProvider.isFavNFT(nft),
                        onFavPressed: () => favProvider.setFavNFT(nft),
                      );
                    },
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class CollectionView extends StatelessWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
