import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../provider/app_provider.dart';
import '../../../provider/fav_provider.dart';
import '../../../provider/user_provider.dart';
import '../../collection_screen/collection_screen.dart';
import '../../nft_screen/nft_screen.dart';

class UserTab extends StatefulWidget {
  const UserTab({Key? key}) : super(key: key);

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<UserTab> {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      if (provider.state == UserState.loading) {
        return const LoadingIndicator();
      }

      final user = provider.user;

      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: rh(284),
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
                          if (provider.user.metadata.isNotEmpty)
                            Buttons.icon(
                              context: context,
                              svgPath: 'assets/images/twitter.svg',
                              right: rw(space2x),
                              semanticLabel: 'twitter',
                              onPressed: () {},
                              // onPressed: () => _openUrl(url),
                            ),
                          if (provider.user.metadata.isNotEmpty)
                            Buttons.icon(
                              context: context,
                              icon: Iconsax.copy,
                              right: rw(space2x),
                              semanticLabel: 'Website',
                              onPressed: () {},
                            ),

                          Buttons.icon(
                              context: context,
                              icon: Iconsax.copy,
                              right: rw(space2x),
                              semanticLabel: 'Copy',
                              onPressed: () =>
                                  copy(provider.user.uAddress.hex)),
                          Buttons.icon(
                            context: context,
                            icon: Iconsax.share,
                            right: rw(space2x),
                            semanticLabel: 'Share',
                            onPressed: () => share(
                              " Creator " + provider.user.uAddress.hex,
                              provider.user.image,
                              provider.user.uAddress.hex,
                            ),
                          ),
                          // Buttons.icon(
                          //   context: context,
                          //   icon: Iconsax.edit_2,
                          //   right: rw(space2x),
                          //   semanticLabel: 'Edit',
                          //   onPressed: () => Navigation.push(
                          //     context,
                          //     screen: const EditUserInfoScreen(),
                          //   ),
                          // ),
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
              Consumer<FavProvider>(builder: (context, favProvider, child) {
                return ListView.separated(
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
                      key: PageStorageKey(nft.tokenId),
                      onTap: () =>
                          Navigation.push(context, screen: NFTScreen(nft: nft)),
                      heroTag: '${nft.cAddress}-${nft.tokenId}',
                      image: nft.image,
                      title: nft.name,
                      subtitle: 'By ' + formatAddress(nft.creator),
                      isFav: favProvider.isFavNFT(nft),
                      onFavPressed: () => favProvider.setFavNFT(nft),
                    );
                  },
                );
              }),

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
                            Consumer<FavProvider>(
                                builder: (context, favProvider, child) {
                              return ListView.separated(
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
                                      isSubtitleVerified: false,
                                      isFav: favProvider
                                          .isFavCollection(collection),
                                      onFavPressed: () => favProvider
                                          .setFavCollection(collection),
                                    ),
                                  );
                                },
                              );
                            }),

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
                        Consumer<FavProvider>(
                            builder: (context, favProvider, child) {
                          return ListView.separated(
                            itemCount: 3,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                              bottom: space3x,
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: rh(space3x));
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final nft = provider.singles[index];
                              return NFTCard(
                                key: PageStorageKey(nft.cAddress),
                                onTap: () => Navigation.push(context,
                                    screen: NFTScreen(nft: nft)),
                                image: nft.image,
                                title: nft.name,
                                subtitle: nft.cName,
                                isFav: favProvider.isFavNFT(nft),
                                onFavPressed: () => favProvider.setFavNFT(nft),
                              );
                            },
                          );
                        }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
