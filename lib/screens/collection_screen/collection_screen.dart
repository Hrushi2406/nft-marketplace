import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../nft_screen/nft_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(),
            SizedBox(height: rh(space2x)),

            //LIST TILE
            const CollectionListTile(
              image: 'assets/images/collection-2.png',
              title: 'Less is More',
              subtitle: 'By The Minimalist',
            ),
            SizedBox(height: rh(space3x)),

            //DESCRIPTION
            Text(
              'UnknownCulturz is a unique limited series of 25 artworks which tells a story in the metaverse.',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: rh(space3x)),

            //INSIGHTS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                UpperCaseText(
                  '25 Items',
                  style: Theme.of(context).textTheme.headline4,
                ),
                UpperCaseText(
                  '|',
                  style: Theme.of(context).textTheme.headline4,
                ),
                UpperCaseText(
                  '24 Owners',
                  style: Theme.of(context).textTheme.headline4,
                ),
                UpperCaseText(
                  '|',
                  style: Theme.of(context).textTheme.headline4,
                ),
                UpperCaseText(
                  '2 ETH Vol',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            SizedBox(height: rh(space3x)),

            //LINKS
            Row(
              children: <Widget>[
                Buttons.icon(
                  context: context,
                  svgPath: 'assets/images/twitter.svg',
                  right: rw(space2x),
                  semanticLabel: 'twitter',
                  onPressed: () {},
                ),
                Buttons.icon(
                  context: context,
                  icon: Iconsax.global5,
                  right: rw(space2x),
                  semanticLabel: 'Website',
                  onPressed: () {},
                ),
                Buttons.icon(
                  context: context,
                  icon: Iconsax.share,
                  right: rw(space2x),
                  top: 0,
                  bottom: 0,
                  semanticLabel: 'Share',
                  onPressed: () {},
                ),
                const Spacer(),
                Buttons.text(
                  context: context,
                  right: 0,
                  text: 'Create NFT',
                  onPressed: () {},
                ),
              ],
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

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: rh(space2x),
                  crossAxisSpacing: rw(space2x),
                ),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () =>
                        Navigation.push(context, screen: const NFTScreen()),
                    child: Hero(
                      tag: '$index',
                      child: _ItemsTile(
                        index: index,
                        title: 'Stuck in time',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsTile extends StatelessWidget {
  const _ItemsTile({
    Key? key,
    required this.index,
    required this.title,
  }) : super(key: key);

  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //BACGROUND IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(space1x),
          child: Image.asset('assets/images/nft-${index + 1}.png'),
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