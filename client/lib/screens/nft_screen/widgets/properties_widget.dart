import 'package:flutter/material.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/provider/nft_provider.dart';
import 'package:provider/provider.dart';

class PropertiesWidget extends StatelessWidget {
  const PropertiesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NFTProvider>(
      builder: (context, provider, child) {
        if (provider.metadata.properties.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpperCaseText(
                'PROPERTIES',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: rh(space2x)),

              Wrap(
                spacing: rw(12),
                runSpacing: rh(12),
                children: provider.metadata.properties
                    .map<Widget>((prop) => PropertiesChip(
                          label: prop['type'],
                          value: prop['value'],
                          percent: '56%',
                        ))
                    .toList(),
                // children: const [
                //   PropertiesChip(
                //     label: 'Accessory',
                //     value: 'Headband',
                //     percent: '56%',
                //   ),
                //   PropertiesChip(
                //     label: 'Accessory',
                //     value: 'Chai',
                //     percent: '40%',
                //   ),
                //   PropertiesChip(
                //     label: 'Style',
                //     value: 'Coolish',
                //     percent: '16%',
                //   ),
                //   PropertiesChip(
                //     label: 'Accessory',
                //     value: 'Something',
                //     percent: '12%',
                //   ),
                // ],
              ),
              //Divider
              SizedBox(height: rh(space2x)),
              const Divider(),
              SizedBox(height: rh(space2x)),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
