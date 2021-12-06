import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    Key? key,
    required this.action,
    this.amount,
    required this.from,
    required this.to,
  }) : super(key: key);

  final String action;
  final String? amount;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //LEFT INFO
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            UpperCaseText(
              action,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: rh(6)),
            Text(
              from,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),

        //Icon
        Transform.rotate(
          angle: pi,
          child: Icon(
            Iconsax.arrow_left,
            size: rf(16),
          ),
        ),

        //RIGHT INFO
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (amount != null)
              UpperCaseText(
                amount!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            if (amount != null) SizedBox(height: rh(6)),
            Text(
              to,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    );
  }
}
