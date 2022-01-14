import 'package:flutter/material.dart';
import '../../utils/ui_helper.dart';

class CustomPlaceHolder extends StatelessWidget {
  const CustomPlaceHolder({
    Key? key,
    this.size,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space1x),
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
