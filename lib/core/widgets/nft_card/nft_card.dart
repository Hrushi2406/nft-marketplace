import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';

class NFTCard extends StatelessWidget {
  const NFTCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.heroTag = 'no-hero',
    this.isVerified = true,
    this.isFav = false,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;
  final String heroTag;

  final bool isVerified;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //NFT IMAGE
        Hero(
          tag: heroTag,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(space1x),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        SizedBox(height: rh(space2x)),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //NFT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Title
                  UpperCaseText(
                    title,
                    style: Theme.of(context).textTheme.headline3,
                  ),

                  SizedBox(height: rh(4)),

                  //Subtitle
                  VerifiedText(
                    text: subtitle,
                    isUpperCase: false,
                    isVerified: isVerified,
                  ),
                ],
              ),
            ),

            // Trailing Icon
            Buttons.icon(
              context: context,
              icon: isFav ? Iconsax.heart5 : Iconsax.heart,
              semanticLabel: 'Heart',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
