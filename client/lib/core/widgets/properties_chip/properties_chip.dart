import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class PropertiesChip extends StatelessWidget {
  const PropertiesChip({
    Key? key,
    required this.label,
    required this.value,
    required this.percent,
    this.onPressed,
  }) : super(key: key);

  final String label;
  final String value;
  final String percent;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: space1x, vertical: space1x),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space1x),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Property Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UpperCaseText(
                label,
                style: Theme.of(context).textTheme.overline,
              ),
              SizedBox(height: rh(4)),
              UpperCaseText(
                value,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),

          SizedBox(width: rw(space2x)),
          //Percent Value
          // UpperCaseText(
          //   percent,
          //   style: Theme.of(context).textTheme.subtitle1,
          // ),

          if (onPressed != null)
            Buttons.icon(
              context: context,
              icon: Icons.close,
              size: rf(16),
              semanticLabel: 'close',
              onPressed: onPressed!,
            ),
        ],
      ),
    );
  }
}
