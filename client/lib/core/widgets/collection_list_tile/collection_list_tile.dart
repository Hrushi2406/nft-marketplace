import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_placeholder/custom_placeholder.dart';
import '../custom_widgets.dart';

class CollectionListTile extends StatelessWidget {
  const CollectionListTile({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onFavPressed,
    this.isTitleVerified = false,
    this.isSubtitleVerified = true,
    this.isFav = false,
    this.showFav = true,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;

  final bool isTitleVerified;
  final bool isSubtitleVerified;

  final bool isFav;
  final bool showFav;

  final VoidCallback? onFavPressed;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$image-$title',
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return SingleChildScrollView(
          child: fromHeroContext.widget,
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Image Leading

            !image.contains('image_picker')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(space1x),
                    child: CachedNetworkImage(
                      imageUrl: 'https://ipfs.io/ipfs/$image',
                      width: rf(56),
                      height: rf(56),
                      fit: BoxFit.cover,
                      placeholder: (_, url) => CustomPlaceHolder(size: rw(56)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(space1x),
                    child: Image.asset(
                      image,
                      width: rw(56),
                      height: rf(56),
                      fit: BoxFit.cover,
                    ),
                  ),

            SizedBox(width: rw(space2x)),

            //Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  VerifiedText(
                    text: title,
                    isVerified: isTitleVerified,
                  ),
                  SizedBox(height: rh(4)),
                  VerifiedText(
                    text: subtitle,
                    isUpperCase: false,
                    isVerified: isSubtitleVerified,
                  ),
                ],
              ),
            ),

            SizedBox(width: rw(space1x)),

            // Trailing Icon
            if (showFav)
              Buttons.icon(
                context: context,
                icon: isFav ? Iconsax.heart5 : Iconsax.heart,
                semanticLabel: 'Heart',
                onPressed: onFavPressed ?? () {},
              ),
          ],
        ),
      ),
    );
  }
}
