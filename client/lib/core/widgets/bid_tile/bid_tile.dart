import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class BidTile extends StatelessWidget {
  const BidTile({
    Key? key,
    required this.text,
    required this.value,
    this.isSelected = false,
  }) : super(key: key);

  final String text;
  final String value;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (isSelected)
          Icon(
            Iconsax.tick_circle4,
            size: rf(14),
          ),
        if (isSelected) SizedBox(width: rw(6)),
        Expanded(
          child: UpperCaseText(
            text,
            style: Theme.of(context).textTheme.headline5,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const Spacer(),
        UpperCaseText(
          value,
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }
}
