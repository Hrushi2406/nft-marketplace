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
        SizedBox(height: rh(70)),
        Expanded(
          child: CustomTabBar(
            titles: const ['Collections', 'NFTS'],
            tabs: [
              //COLLECTION VIEW
              ListView.separated(
                itemCount: 10,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: rh(space2x));
                },
                itemBuilder: (BuildContext context, int index) {
                  return CollectionListTile(
                    image: 'assets/images/collection-2.png',
                    title: 'Less is more',
                    subtitle: 'By The Minimalist',
                  );
                },
              ),

//NFT VIEW

              ListView.separated(
                itemCount: 10,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: rh(space2x));
                },
                itemBuilder: (BuildContext context, int index) {
                  return CollectionListTile(
                    image: 'assets/images/collection-2.png',
                    title: 'Less is more',
                    subtitle: 'By The Minimalist',
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
