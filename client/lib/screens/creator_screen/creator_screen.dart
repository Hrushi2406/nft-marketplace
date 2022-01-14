import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../provider/creator_provider.dart';
import '../../provider/fav_provider.dart';
import '../collection_screen/collection_screen.dart';
import '../nft_screen/nft_screen.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({Key? key, required this.owner}) : super(key: key);

  final String owner;

  @override
  _CreatorScreenState createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CreatorScreen> {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    init();
  }

  init() {
    Provider.of<CreatorProvider>(context, listen: false)
        .fetchCreatorInfo(widget.owner);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CreatorProvider>(builder: (context, provider, child) {
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
                expandedHeight: rh(210),
                toolbarHeight: 0,
                collapsedHeight: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: space2x),
                        child: CustomAppBar(),
                      ),
                      SizedBox(height: rh(space1x)),

                      ///USER INFO
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: space2x),
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: space2x),
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
                                icon: Iconsax.global5,
                                right: rw(space2x),
                                semanticLabel: 'Website',
                                onPressed: () {},
                              ),
                            Buttons.icon(
                              context: context,
                              icon: Iconsax.copy,
                              right: rw(space2x),
                              semanticLabel: 'Copy',
                              onPressed: () => copy(provider.user.uAddress.hex),
                            ),
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
                          ],
                        ),
                      ),

                      SizedBox(height: rh(space3x)),
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
          body: (provider.state == CreatorState.loading)
              ? const LoadingIndicator()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    //COLLECTED UI

                    if (provider.collectedNFTs.isEmpty)
                      const EmptyWidget(text: 'Nothing Collected yet')
                    else
                      Consumer<FavProvider>(
                          builder: (context, favProvider, child) {
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
                              onTap: () => Navigation.push(context,
                                  screen: NFTScreen(nft: nft)),
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
                    if (provider.createdCollections.isEmpty &&
                        provider.singles.isEmpty)
                      const EmptyWidget(text: 'Nothing Created yet')
                    else
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: space2x),
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
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    SizedBox(height: rh(space3x)),
                                    Consumer<FavProvider>(
                                        builder: (context, favProvider, child) {
                                      return ListView.separated(
                                        itemCount:
                                            provider.createdCollections.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(height: rh(space2x));
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final collection = provider
                                              .createdCollections[index];

                                          return GestureDetector(
                                            onTap: () =>
                                                Navigation.push(context,
                                                    screen: CollectionScreen(
                                                      collection: collection,
                                                    )),
                                            child: CollectionListTile(
                                              image: collection.image,
                                              title: collection.name,
                                              subtitle:
                                                  '${collection.nItems} items',
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                      bottom: space3x,
                                    ),
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(height: rh(space3x));
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final nft = provider.singles[index];
                                      return NFTCard(
                                        onTap: () => Navigation.push(context,
                                            screen: NFTScreen(nft: nft)),
                                        image: nft.image,
                                        title: nft.name,
                                        subtitle: nft.cName,
                                        isFav: favProvider.isFavNFT(nft),
                                        onFavPressed: () =>
                                            favProvider.setFavNFT(nft),
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
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
