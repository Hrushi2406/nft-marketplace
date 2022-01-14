import 'package:flutter/material.dart';
import '../../../core/animations/animations.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/nft_provider.dart';
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
          return FadeAnimation(
            // begin: const Offset(0, 10),
            child: Column(
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
                ),
                //Divider
                SizedBox(height: rh(space2x)),
                const Divider(),
                SizedBox(height: rh(space2x)),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
