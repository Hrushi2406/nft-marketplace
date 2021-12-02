import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';

class FavTab extends StatelessWidget {
  const FavTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: rh(60)),
        Expanded(
          child: CustomTabBar(
            titles: const ['Collections', 'NFTS'],
            tabs: [
              //COLLECTION VIEW
              ListView.separated(
                itemCount: 3,
                padding: const EdgeInsets.only(
                  left: space2x,
                  right: space2x,
                  bottom: space3x,
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: rh(space2x));
                },
                itemBuilder: (BuildContext context, int index) {
                  return CollectionListTile(
                    image: 'assets/images/collection-${index + 1}.png',
                    title: 'Less is more',
                    subtitle: 'By The Minimalist',
                  );
                },
              ),

              //NFT VIEW
              ListView.separated(
                itemCount: 3,
                padding: const EdgeInsets.only(
                  left: space2x,
                  right: space2x,
                  bottom: space3x,
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: rh(space3x));
                },
                itemBuilder: (BuildContext context, int index) {
                  return NFTCard(
                    image: 'assets/images/nft-${index + 1}.png',
                    title: 'Less is more',
                    subtitle: 'By The Minimalist',
                    isFav: true,
                  );
                },
              ),
            ],
          ),
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
