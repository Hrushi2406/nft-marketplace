import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../custom_placeholder/custom_placeholder.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class DataInfoChip extends StatelessWidget {
  const DataInfoChip({
    Key? key,
    required this.image,
    required this.label,
    required this.value,
    required this.onTap,
    this.isVerified = true,
  }) : super(key: key);

  final String image;
  final String label;
  final String value;

  final bool isVerified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            //Leading Image
            ClipRRect(
              borderRadius: BorderRadius.circular(space1x),
              child: CachedNetworkImage(
                imageUrl: 'https://ipfs.io/ipfs/$image',
                width: rf(40),
                height: rf(40),
                fit: BoxFit.cover,
                placeholder: (_, url) => CustomPlaceHolder(size: rw(56)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),

              // Image.asset(
              //   image,
              //   width: rw(40),
              //   fit: BoxFit.cover,
              // ),
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
        ),
      ),
    );
  }
}
