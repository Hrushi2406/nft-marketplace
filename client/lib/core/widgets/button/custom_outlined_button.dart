import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  final double? width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      padding: const EdgeInsets.all(0),
      height: rh(40),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space1x),
        side: const BorderSide(width: 1),
      ),
      child: UpperCaseText(
        text,
        style:
            Theme.of(context).textTheme.button!.copyWith(color: Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
