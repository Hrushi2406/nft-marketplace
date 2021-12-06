import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../edit_user_info_screen/edit_user_info_screen.dart';

class UserTab extends StatefulWidget {
  const UserTab({Key? key}) : super(key: key);

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _createNFT() {}

  _createCollection() {}

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool isBoxScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 0,
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: rh(270),
            toolbarHeight: 0,
            collapsedHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: rh(70)),

                  ///USER INFO
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: space2x),
                    child: CollectionListTile(
                      image: 'assets/images/collection-2.png',
                      title: 'Roger Belson',
                      subtitle: '0xdB...5aE7',
                      showFav: false,
                      isTitleVerified: true,
                      isSubtitleVerified: false,
                    ),
                  ),

                  SizedBox(height: rh(space3x)),

                  //LINKS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: space2x),
                    child: Row(
                      children: <Widget>[
                        Buttons.icon(
                          context: context,
                          svgPath: 'assets/images/twitter.svg',
                          right: rw(space2x),
                          semanticLabel: 'twitter',
                          onPressed: () {},
                        ),
                        Buttons.icon(
                          context: context,
                          icon: Iconsax.global5,
                          right: rw(space2x),
                          semanticLabel: 'Website',
                          onPressed: () {},
                        ),
                        Buttons.icon(
                          context: context,
                          icon: Iconsax.share,
                          right: rw(space2x),
                          semanticLabel: 'Share',
                          onPressed: () {},
                        ),
                        Buttons.icon(
                          context: context,
                          icon: Iconsax.edit_2,
                          right: rw(space2x),
                          semanticLabel: 'Edit',
                          onPressed: () => Navigation.push(
                            context,
                            screen: const EditUserInfoScreen(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: rh(space3x)),

                  //BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: space2x),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomOutlinedButton(
                            text: 'Create Collection',
                            onPressed: _createCollection,
                          ),
                        ),
                        SizedBox(width: rw(space2x)),
                        Expanded(
                          child: Buttons.flexible(
                            context: context,
                            text: 'Create NFT',
                            onPressed: _createNFT,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: rh(space2x)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: space2x),
                    child: Divider(),
                  ),
                  SizedBox(height: rh(space1x)),
                ],
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorWeight: 1.4,
              indicatorColor: Colors.black,
              labelStyle: Theme.of(context).textTheme.headline3,
              labelPadding: const EdgeInsets.symmetric(horizontal: space2x),
              unselectedLabelStyle: Theme.of(context).textTheme.headline5,
              tabs: [
                Tab(
                  text: 'Collected'.toUpperCase(),
                  height: rh(30),
                ),
                Tab(
                  text: 'Created'.toUpperCase(),
                  height: rh(30),
                ),
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          //COLLECTED UI

          ListView.separated(
            itemCount: 3,
            padding: const EdgeInsets.only(
              left: space2x,
              right: space2x,
              bottom: space3x,
              top: space3x,
            ),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: rh(space3x));
            },
            itemBuilder: (BuildContext context, int index) {
              return NFTCard(
                onTap: () {},
                image: 'assets/images/nft-${index + 1}.png',
                title: 'Less is more',
                subtitle: 'By The Minimalist',
                isFav: true,
              );
            },
          ),

          //CREATED UI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: space2x),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: rh(space3x)),
                  //COLLECTIONS
                  UpperCaseText(
                    'Collections',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: rh(space3x)),

                  ListView.separated(
                    itemCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space2x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return CollectionListTile(
                        image: 'assets/images/nft-${index + 1}.png',
                        title: 'Less is more',
                        subtitle: 'By The Minimalist',
                        isFav: true,
                      );
                    },
                  ),

                  SizedBox(height: rh(space3x)),
                  const Divider(),
                  SizedBox(height: rh(space3x)),

                  //SINGLES
                  UpperCaseText(
                    'Singles',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: rh(space3x)),

                  ListView.separated(
                    itemCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      bottom: space3x,
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: rh(space3x));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return NFTCard(
                        onTap: () {},
                        image: 'assets/images/nft-${index + 1}.png',
                        title: 'Less is more',
                        subtitle: 'By The Minimalist',
                        isFav: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     SizedBox(height: rh(70)),

    //     ///USER INFO
    //     const Padding(
    //       padding: EdgeInsets.symmetric(horizontal: space2x),
    //       child: CollectionListTile(
    //         image: 'assets/images/collection-2.png',
    //         title: 'Roger Belson',
    //         subtitle: '0xdB...5aE7',
    //         showFav: false,
    //         isTitleVerified: true,
    //         isSubtitleVerified: false,
    //       ),
    //     ),

    //     SizedBox(height: rh(space3x)),

    //     //LINKS
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: space2x),
    //       child: Row(
    //         children: <Widget>[
    //           Buttons.icon(
    //             context: context,
    //             svgPath: 'assets/images/twitter.svg',
    //             right: rw(space2x),
    //             semanticLabel: 'twitter',
    //             onPressed: () {},
    //           ),
    //           Buttons.icon(
    //             context: context,
    //             icon: Iconsax.global5,
    //             right: rw(space2x),
    //             semanticLabel: 'Website',
    //             onPressed: () {},
    //           ),
    //           Buttons.icon(
    //             context: context,
    //             icon: Iconsax.share,
    //             right: rw(space2x),
    //             semanticLabel: 'Share',
    //             onPressed: () {},
    //           ),
    //           Buttons.icon(
    //             context: context,
    //             icon: Iconsax.edit_2,
    //             right: rw(space2x),
    //             semanticLabel: 'Edit',
    //             onPressed: () => Navigation.push(
    //               context,
    //               screen: const EditUserInfoScreen(),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),

    //     SizedBox(height: rh(space3x)),

    //     //BUTTONS
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: space2x),
    //       child: Row(
    //         children: <Widget>[
    //           Expanded(
    //             child: CustomOutlinedButton(
    //               text: 'Create Collection',
    //               onPressed: _createCollection,
    //             ),
    //           ),
    //           SizedBox(width: rw(space2x)),
    //           Expanded(
    //             child: Buttons.flexible(
    //               context: context,
    //               text: 'Create NFT',
    //               onPressed: _createNFT,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),

    //     SizedBox(height: rh(space2x)),
    //     const Padding(
    //       padding: EdgeInsets.symmetric(horizontal: space2x),
    //       child: Divider(),
    //     ),
    //     SizedBox(height: rh(space1x)),

    //     //TAB BAR

    //     Expanded(
    //       child: CustomTabBar(
    //         titles: const ['Collected', 'Created'],
    //         tabs: [
    //           //COLLECTED UI

    //           ListView.separated(
    //             itemCount: 3,
    //             padding: const EdgeInsets.only(
    //               left: space2x,
    //               right: space2x,
    //               bottom: space3x,
    //             ),
    //             separatorBuilder: (BuildContext context, int index) {
    //               return SizedBox(height: rh(space3x));
    //             },
    //             itemBuilder: (BuildContext context, int index) {
    //               return NFTCard(
    //                 image: 'assets/images/nft-${index + 1}.png',
    //                 title: 'Less is more',
    //                 subtitle: 'By The Minimalist',
    //                 isFav: true,
    //               );
    //             },
    //           ),

    //           //CREATED UI
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: space2x),
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   //COLLECTIONS
    //                   UpperCaseText(
    //                     'Collections',
    //                     style: Theme.of(context).textTheme.headline5,
    //                   ),
    //                   SizedBox(height: rh(space2x)),

    //                   ListView.separated(
    //                     itemCount: 3,
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     shrinkWrap: true,
    //                     padding: EdgeInsets.zero,
    //                     separatorBuilder: (BuildContext context, int index) {
    //                       return SizedBox(height: rh(space3x));
    //                     },
    //                     itemBuilder: (BuildContext context, int index) {
    //                       return CollectionListTile(
    //                         image: 'assets/images/nft-${index + 1}.png',
    //                         title: 'Less is more',
    //                         subtitle: 'By The Minimalist',
    //                         isFav: true,
    //                       );
    //                     },
    //                   ),

    //                   SizedBox(height: rh(space3x)),
    //                   const Divider(),
    //                   SizedBox(height: rh(space3x)),

    //                   //SINGLES
    //                   UpperCaseText(
    //                     'Singles',
    //                     style: Theme.of(context).textTheme.headline5,
    //                   ),
    //                   SizedBox(height: rh(space2x)),

    //                   ListView.separated(
    //                     itemCount: 3,
    //                     physics: const NeverScrollableScrollPhysics(),
    //                     shrinkWrap: true,
    //                     padding: const EdgeInsets.only(
    //                       bottom: space3x,
    //                     ),
    //                     separatorBuilder: (BuildContext context, int index) {
    //                       return SizedBox(height: rh(space3x));
    //                     },
    //                     itemBuilder: (BuildContext context, int index) {
    //                       return NFTCard(
    //                         image: 'assets/images/nft-${index + 1}.png',
    //                         title: 'Less is more',
    //                         subtitle: 'By The Minimalist',
    //                         isFav: true,
    //                       );
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}