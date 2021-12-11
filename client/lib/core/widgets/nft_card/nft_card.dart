import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_placeholder/custom_placeholder.dart';
import '../custom_widgets.dart';

class NFTCard extends StatelessWidget {
  const NFTCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.heroTag = 'no-hero',
    this.isVerified = true,
    this.isFav = false,
    required this.onFavPressed,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;
  final String heroTag;

  final bool isVerified;
  final bool isFav;

  final VoidCallback onTap;
  final VoidCallback onFavPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //NFT IMAGE
          Hero(
            tag: heroTag,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(space1x),
                child: image.contains('assets')
                    ? Image.asset(
                        image,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: 'https://ipfs.io/ipfs/$image',
                        fit: BoxFit.cover,
                        placeholder: (_, url) => const CustomPlaceHolder(),
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
                onPressed: onFavPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
