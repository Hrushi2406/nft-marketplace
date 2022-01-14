import 'package:flutter/material.dart';

import '../../../core/animations/animations.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.label,
    required this.price,
    required this.buttonText,
    this.onlyText,
    this.icon,
    this.onIconPressed,
    this.onButtonPressed,
  }) : super(key: key);

  final String label;
  final String price;

  final String buttonText;
  final IconData? icon;

  final VoidCallback? onIconPressed;
  final VoidCallback? onButtonPressed;

  final String? onlyText;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      width: double.infinity,
      padding: EdgeInsets.only(
        top: space2x,
        left: space2x,
        right: space2x,
        bottom: onlyText == null ? space2x : space2x,
      ),
      color: Theme.of(context).colorScheme.surface,
      child: onlyText != null
          ? Center(
              child: UpperCaseText(
                onlyText!,
                style: Theme.of(context).textTheme.headline4,
              ),
            )
          : FadeAnimation(
              // begin: const Offset(0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: onIconPressed ?? () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            UpperCaseText(
                              label,
                              style: price.isEmpty
                                  ? Theme.of(context).textTheme.headline3
                                  : Theme.of(context).textTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: rw(4)),
                            if (icon != null)
                              Icon(
                                icon,
                                size: rf(14),
                              ),
                          ],
                        ),
                        SizedBox(height: rh(2)),
                        if (price.isNotEmpty)
                          SizedBox(
                            width: rw(180),
                            child: UpperCaseText(
                              price,
                              style: Theme.of(context).textTheme.headline1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                      ],
                    ),
                  ),

                  //ACTION BUTTON
                  if (buttonText.isNotEmpty)
                    Buttons.flexible(
                      width: rw(150),
                      context: context,
                      text: buttonText,
                      onPressed: onButtonPressed ?? () {},
                    ),
                ],
              ),
            ),
    );
  }
}
