import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nfts/provider/wallet_provider.dart';
import 'package:nfts/screens/collection_screen/collection_screen.dart';
import 'package:nfts/screens/create_collection_screen/create_collection_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/app_provider.dart';
import '../../../provider/creator_provider.dart';
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

  _logOut() {
    Provider.of<AppProvider>(context, listen: false).logOut(context);
  }

  _createNFT() {
    Navigation.push(
      context,
      name: 'create_nft',
    );
  }

  _createCollection() async {
    await Navigation.push(
      context,
      name: 'create_collection',
    );

    Provider.of<CreatorProvider>(context, listen: false).fetchCreatorInfo(
      Provider.of<WalletProvider>(context, listen: false).address,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorProvider>(builder: (context, provider, child) {
      if (provider.state == CreatorState.loading) {
        return const LoadingIndicator();
      }

      final user = provider.user!;

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: space2x),
                      child: CollectionListTile(
                        image: user.image,
                        title: user.name,
                        subtitle: formatAddress(user.uAddress.hex),
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
                          Buttons.icon(
                            context: context,
                            // icon: Icons.exit_to_app_rounded,
                            icon: Iconsax.logout,
                            right: rw(space2x),
                            semanticLabel: 'Share',
                            onPressed: _logOut,
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

            if (provider.collectedNFTs.isEmpty)
              const EmptyWidget(text: 'Nothing Collected yet')
            else
              ListView.separated(
                itemCount: provider.collectedNFTs.length,
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
                  final nft = provider.collectedNFTs[index];
                  return NFTCard(
                    onTap: () {},
                    image: nft.image,
                    title: nft.name,
                    subtitle: 'By ' + formatAddress(nft.creator),
                    isFav: true,
                  );
                },
              ),

            //CREATED UI
            if (provider.createdCollections.isEmpty && provider.singles.isEmpty)
              const EmptyWidget(text: 'Nothing Created yet')
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: space2x),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: rh(space3x)),
                      //COLLECTIONS
                      if (provider.createdCollections.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            UpperCaseText(
                              'Collections',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            SizedBox(height: rh(space3x)),
                            ListView.separated(
                              itemCount: provider.createdCollections.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(height: rh(space2x));
                              },
                              itemBuilder: (BuildContext context, int index) {
                                final collection =
                                    provider.createdCollections[index];

                                return GestureDetector(
                                  onTap: () => Navigation.push(context,
                                      screen: CollectionScreen(
                                        collection: collection,
                                      )),
                                  child: CollectionListTile(
                                    image: collection.image,
                                    title: collection.name,
                                    subtitle: '${collection.nItems} items',
                                    // 'By ${formatAddress(collection.creator)}',
                                    isFav: true,
                                  ),
                                );
                              },
                            ),

                            //DIVIDER
                            SizedBox(height: rh(space3x)),
                            const Divider(),
                            SizedBox(height: rh(space3x)),
                          ],
                        ),

                      //SINGLES

                      if (provider.singles.isNotEmpty)
                        UpperCaseText(
                          'Singles',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      if (provider.singles.isNotEmpty)
                        SizedBox(height: rh(space3x)),

                      if (provider.singles.isNotEmpty)
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
    });
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
