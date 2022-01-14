import 'package:flutter/material.dart';
import '../core/utils/utils.dart';
import '../core/widgets/custom_widgets.dart';

class Scratch extends StatelessWidget {
  const Scratch({Key? key}) : super(key: key);

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
              // const CollectionListTile(
              //   image: 'assets/images/collection-2.png',
              //   title: 'Way into the woods',
              //   subtitle: 'By Nature',
              // ),
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
                  // Expanded(
                  //   child: DataInfoChip(
                  //     image: 'assets/images/collection-2.png',
                  //     label: 'From collection',
                  //     value: 'The minimalist',
                  //   ),
                  // ),
                  // Expanded(
                  //   child: DataInfoChip(
                  //     image: 'assets/images/collection-3.png',
                  //     label: 'Owned by',
                  //     value: 'Roger Belson',
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: rh(30)),
              SizedBox(
                height: rh(100),
                child: const CustomTabBar(
                  titles: ['Created', 'Collected', 'Info', 'Details'],
                  tabs: [
                    Text('Created'),
                    Text('Collected'),
                    Text('Info'),
                    Text('Details'),
                  ],
                ),
              ),
              SizedBox(height: rh(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      text: 'Create Collection',
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: rw(space2x)),
                  Expanded(
                    child: Buttons.flexible(
                      // width: double.infinity,
                      context: context,
                      // isLoading: true,
                      text: 'Place bid',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: rh(30)),
              Buttons.text(
                context: context,
                text: 'Create NFT',
                onPressed: () {},
              ),
              SizedBox(height: rh(30)),
              const ActivityTile(
                action: 'Transfered',
                from: 'Hrushikesh Kuklare',
                to: 'Sumit Mahajan',
                amount: '1.8 ETH',
              ),
              SizedBox(height: rh(30)),
              const DataTile(
                label: 'Contract Address',
                value: '0xdB12fcd1849d409476729EaA454e8D599A4b5aE7',
              ),
              SizedBox(height: rh(30)),
              SizedBox(height: rh(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  PropertiesChip(
                    label: 'Accessory',
                    value: 'Headband',
                    percent: '56%',
                  ),
                  PropertiesChip(
                    label: 'Accessory',
                    value: 'Chai',
                    percent: '40%',
                  ),
                  PropertiesChip(
                    label: 'Style',
                    value: 'Coolish',
                    percent: '16%',
                  ),
                ],
              ),
              SizedBox(height: rh(60)),
              // NFTCard(
              //   onTap: () {},
              //   image: 'assets/images/nft-2.png',
              //   title: 'Woven into fabric',
              //   subtitle: 'Fabric Cloths',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
