import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/ui_helper.dart';
import '../custom_widgets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    this.title = '',
    this.isTitleCentered,
    this.hasBackButton = true,
    this.isHeroAnimated = true,
    this.actions,
  });

  ///Title of text
  final String title;

  ///Should the title be centered
  ///
  ///[Default is null]
  final bool? isTitleCentered;

  ///Platform adaptive back icon
  ///
  ///[Default is true]
  final bool hasBackButton;

  ///The widgets are rendered from end
  final List<Widget>? actions;

  ///Is Hero animated
  final bool isHeroAnimated;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: isHeroAnimated ? 'app_bar' : 'no_hero_animation',
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.only(
            top: rh(50),
            bottom: rh(16),
          ),
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              //Back Button
              if (hasBackButton)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: PlatformIcon(),
                ),

              //Main Heading and Title
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.center,
                child: UpperCaseText(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        height: rf(1.5),
                      ),
                ),
              ),

              //Actions
              if (actions != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlatformIcon extends StatelessWidget {
  const PlatformIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Buttons.icon(
        context: context,
        icon: CupertinoIcons.back,
        right: 12,
        semanticLabel: 'Back',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return Buttons.icon(
        context: context,
        icon: Icons.arrow_back_sharp,
        right: 12,
        semanticLabel: 'Back',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }
}
