import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class DataTile extends StatelessWidget {
  const DataTile({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.isValueBold = true,
    this.onIconPressed,
  }) : super(key: key);

  final String label;
  final String value;
  final IconData? icon;
  final bool isValueBold;
  final VoidCallback? onIconPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Data info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UpperCaseText(
                label,
                // style: Theme.of(context).textTheme.overline,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: rh(6)),
              UpperCaseText(
                value,
                // style: Theme.of(context).textTheme.bodyText2,
                style: isValueBold
                    ? Theme.of(context).textTheme.headline4
                    : Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        //Icon
        if (icon != null)
          Buttons.icon(
            context: context,
            icon: icon,
            size: rf(18),
            semanticLabel: 'Copy',
            onPressed: onIconPressed ?? () {},
          ),
      ],
    );
  }
}
