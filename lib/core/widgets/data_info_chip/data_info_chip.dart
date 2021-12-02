import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class DataInfoChip extends StatelessWidget {
  const DataInfoChip({
    Key? key,
    required this.image,
    required this.label,
    required this.value,
    this.isVerified = true,
  }) : super(key: key);

  final String image;
  final String label;
  final String value;

  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Leading Image
        ClipRRect(
          borderRadius: BorderRadius.circular(space1x),
          child: Image.asset(
            image,
            width: rw(40),
            fit: BoxFit.cover,
          ),
        ),

        SizedBox(width: rw(8)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UpperCaseText(
                label,
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: rh(4)),
              VerifiedText(
                text: value,
                style: Theme.of(context).textTheme.bodyText2,
                isVerified: isVerified,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
