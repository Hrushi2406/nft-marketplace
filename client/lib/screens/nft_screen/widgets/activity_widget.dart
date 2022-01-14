import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/animations/animations.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/nft_provider.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NFTProvider>(
      builder: (context, provider, child) {
        if (provider.activities.isNotEmpty) {
          return FadeAnimation(
            // begin: const Offset(0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpperCaseText(
                  'Activity',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: rh(space3x)),

                //ACITIVITY LIST
                ListView.separated(
                  itemCount: provider.activities.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: rh(space3x));
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final activity = provider.activities[index];
                    return ActivityTile(
                      action: activity.eventType,
                      from: formatAddress(activity.from),
                      to: formatAddress(activity.to),
                      amount: activity.eventType == 'Minted'
                          ? null
                          : '${activity.price} MAT',
                    );
                  },
                ),

//SPACER
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
