import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../animations/scale_animation.dart';
import '../../utils/utils.dart';
import '../custom_widgets.dart';

class BidTile extends StatelessWidget {
  const BidTile({
    Key? key,
    required this.text,
    required this.value,
    this.isSelected = false,
    this.isFontRegular = false,
  }) : super(key: key);

  final String text;
  final String value;
  final bool isSelected;
  final bool isFontRegular;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (isSelected)
          ScaleAnimation(
            child: SvgPicture.asset(
              'assets/images/tick.svg',
              width: rf(16),
            ),
          ),
        if (isSelected) SizedBox(width: rw(6)),
        Expanded(
          child: isFontRegular
              ? Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : UpperCaseText(
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
