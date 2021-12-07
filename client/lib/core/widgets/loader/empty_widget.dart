import 'package:flutter/material.dart';

import '../custom_widgets.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    this.text = "Not found",
    this.style,
  });

  final String text;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UpperCaseText(
        text,
        style: style,
      ),
    );
  }
}
