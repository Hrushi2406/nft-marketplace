import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import 'widgets/bottom_bar.dart';

class NFTScreen extends StatefulWidget {
  const NFTScreen({Key? key}) : super(key: key);

  @override
  _NFTScreenState createState() => _NFTScreenState();
}

class _NFTScreenState extends State<NFTScreen> {
  _openBids() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: space2x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: rh(space3x)),
              //MY BID
              UpperCaseText(
                'My Bids',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: rh(space2x)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UpperCaseText(
                    '8.5 ETH',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Buttons.text(
                    context: context,
                    right: 0,
                    text: 'Cancel',
                    onPressed: () {},
                  ),
                ],
              ),

              SizedBox(height: rh(space2x)),
              const Divider(),
              SizedBox(height: rh(space2x)),

              //OTHER BIDS
              UpperCaseText(
                'Bids',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: rh(space2x)),

              const BidTile(text: 'Hrushikesh Kuklare', value: '10.5 ETH'),
              SizedBox(height: rh(space2x)),
              const BidTile(
                text: 'Hrushikesh Kuklare',
                value: '10.5 ETH',
                isSelected: true,
              ),
              SizedBox(height: rh(space2x)),
              const BidTile(text: 'Hrushikesh Kuklare', value: '10.5 ETH'),
              SizedBox(height: rh(space2x)),
              const BidTile(text: 'Hrushikesh Kuklare', value: '10.5 ETH'),

              const Spacer(),

              //Bottom Bar
              BottomBar(
                label: 'Highest Bid',
                price: '10 MAT',
                buttonText: 'Place Bid',
                icon: Iconsax.arrow_down_1,
                onTap: () => Navigation.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          children: [
            //SCROLLABLE PART
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(),
                    SizedBox(height: rh(space2x)),

                    //IMAGE
                    Hero(
                      tag: '2',
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(space1x),
                          child: Image.asset('assets/images/nft-3.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: rh(space2x)),

                    //TITLE & DESCRIPTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UpperCaseText(
                          'The Art Of Racing In Rain',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Buttons.icon(
                          context: context,
                          icon: Iconsax.heart,
                          semanticLabel: 'Heart',
                          onPressed: () {},
                        )
                      ],
                    ),
                    SizedBox(height: rh(space3x)),
                    Text(
                      'Minimalism is all about owning only what adds value and meaning to your life and removing the rest.',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: rh(space3x)),

                    //OWNER INFO
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

                    SizedBox(height: rh(space2x)),
                    const Divider(),
                    SizedBox(height: rh(space2x)),

                    //PROPERTIES
                    UpperCaseText(
                      'PROPERTIES',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: rh(space2x)),

                    Wrap(
                      spacing: rw(12),
                      runSpacing: rh(12),
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
                        PropertiesChip(
                          label: 'Accessory',
                          value: 'Something',
                          percent: '12%',
                        ),
                      ],
                    ),

                    SizedBox(height: rh(space2x)),
                    const Divider(),
                    SizedBox(height: rh(space2x)),

                    //ACTIVITY
                    UpperCaseText(
                      'Activity',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: rh(space3x)),

                    ListView.separated(
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: rh(space3x));
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return const ActivityTile(
                          action: 'Transfered',
                          from: 'Hrushikesh Kuklare',
                          to: 'Sumit Mahajan',
                          amount: '1.8 ETH',
                        );
                      },
                    ),

                    SizedBox(height: rh(space2x)),
                    const Divider(),
                    SizedBox(height: rh(space2x)),

                    //CONTRACT DETAILS
                    UpperCaseText(
                      'Contract Details',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: rh(space3x)),

                    const DataTile(
                      label: 'Contract Address',
                      value: '0xdB12fcd1849d409476729EaA454e8D599A4b5aE7',
                    ),
                    SizedBox(height: rh(space2x)),
                    const DataTile(
                      label: 'Token id',
                      value: '1028',
                    ),
                    SizedBox(height: rh(space2x)),
                    const DataTile(
                      label: 'Token Standard',
                      value: 'ERC 721',
                    ),
                    SizedBox(height: rh(space2x)),
                    const DataTile(
                      label: 'Blockchain',
                      value: 'Ethereum',
                    ),
                    SizedBox(height: rh(space6x)),
                  ],
                ),
              ),
            ),

            //FIXED PART
            BottomBar(
              label: 'Highest Bid',
              price: '10 MAT',
              buttonText: 'Place Bid',
              icon: Iconsax.arrow_up_2,
              onTap: _openBids,
            )
          ],
        ),
      ),
    );
  }
}
