import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/utils.dart';
import '../custom_widgets.dart';
import '../verified_text/verified_text.dart';

class CollectionListTile extends StatelessWidget {
  const CollectionListTile({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // child: Image.asset(name)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Image Leading
          ClipRRect(
            borderRadius: BorderRadius.circular(space1x),
            child: Image.asset(
              image,
              width: rw(56),
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
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}
