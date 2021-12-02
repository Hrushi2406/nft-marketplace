import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class VerifiedText extends StatelessWidget {
  const VerifiedText({
    Key? key,
    required this.text,
    this.isVerified = false,
    this.isUpperCase = true,
  }) : super(key: key);

  final String text;

  final bool isUpperCase;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (isUpperCase)
          Flexible(
            child: UpperCaseText(
              text,
              style: Theme.of(context).textTheme.headline3,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              // softWrap: false,
            ),
          )
        else
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        SizedBox(width: rw(3)),
        if (isVerified)
          Icon(
            Iconsax.verify5,
            size: rf(13),
          ),
      ],
    );
  }
}
