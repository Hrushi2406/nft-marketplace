import 'package:flutter/material.dart';
import 'package:nfts/core/widgets/nft_card/nft_card.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/collection_list_tile/collection_list_tile.dart';

class WalletInitScreen extends StatefulWidget {
  const WalletInitScreen({Key? key}) : super(key: key);

  @override
  _WalletInitScreenState createState() => _WalletInitScreenState();
}

class _WalletInitScreenState extends State<WalletInitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: rh(100)),
            const CollectionListTile(
              image: 'assets/images/collection-2.png',
              title: 'Way into the woods',
              subtitle: 'By Nature',
            ),
            SizedBox(height: rh(60)),
            const NFTCard(
              image: 'assets/images/nft-1.png',
              title: 'Woven into fabric',
              subtitle: 'Fabric Cloths',
            ),
          ],
        ),
      ),
    );
  }
}
