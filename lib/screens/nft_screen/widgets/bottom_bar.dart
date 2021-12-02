import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.label,
    required this.price,
    required this.buttonText,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final String price;

  final String buttonText;
  final IconData icon;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: space2x,
        bottom: space3x,
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    UpperCaseText(
                      label,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(width: rw(4)),
                    Icon(
                      icon,
                      size: rf(14),
                    ),
                  ],
                ),
                SizedBox(height: rh(2)),
                UpperCaseText(
                  price,
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
          ),

          //ACTION BUTTON
          Buttons.flexible(
            width: rw(150),
            context: context,
            text: buttonText,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
