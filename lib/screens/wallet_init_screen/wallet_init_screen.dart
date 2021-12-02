import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/collection_list_tile/collection_list_tile.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../core/widgets/data_info_chip/data_info_chip.dart';
import '../../core/widgets/nft_card/nft_card.dart';

class WalletInitScreen extends StatefulWidget {
  const WalletInitScreen({Key? key}) : super(key: key);

  @override
  _WalletInitScreenState createState() => _WalletInitScreenState();
}

class _WalletInitScreenState extends State<WalletInitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
              const BidTile(
                text: 'Hrushikesh Kuklare',
                isSelected: true,
                value: '11.5 ETH',
              ),
              SizedBox(height: rh(16)),
              const BidTile(
                text: 'Hrushikesh Kuklare',
                value: '11.5 ETH',
              ),
              SizedBox(height: rh(60)),
              Row(
                children: const [
                  Expanded(
                    child: DataInfoChip(
                      image: 'assets/images/collection-2.png',
                      label: 'From collection',
                      value: 'The minimalist',
                    ),
                  ),
                  Expanded(
                    child: DataInfoChip(
                      image: 'assets/images/collection-3.png',
                      label: 'Owned by',
                      value: 'Roger Belson',
                    ),
                  ),
                ],
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
      ),
    );
  }
}
