import 'package:flutter/material.dart';

import '../../../core/animations/animations.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';

class SelectableContainer extends StatelessWidget {
  const SelectableContainer({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final bool isSelected;

  final String text;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: rh(40),
        padding: const EdgeInsets.symmetric(horizontal: space3x),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space1x),
          color: Theme.of(context).colorScheme.surface,
          border: isSelected ? Border.all(width: 1) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isSelected)
              FadeAnimation(
                child: Icon(
                  Icons.check_circle,
                  size: rf(18),
                ),
              ),
            if (isSelected) SizedBox(width: rw(space1x)),
            Center(
              child: UpperCaseText(
                text,
                style: isSelected
                    ? Theme.of(context).textTheme.headline3
                    : Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
