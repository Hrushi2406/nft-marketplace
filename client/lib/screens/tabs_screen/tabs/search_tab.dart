import 'package:flutter/material.dart';
import 'package:nfts/core/utils/debouncer.dart';
import 'package:nfts/core/utils/enum.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/core/widgets/text_field/custom_text_form_field.dart';
import 'package:nfts/models/collection.dart';
import 'package:nfts/models/nft.dart';
import 'package:nfts/provider/fav_provider.dart';
import 'package:nfts/provider/search_provider.dart';
import 'package:nfts/screens/collection_screen/collection_screen.dart';
import 'package:nfts/screens/nft_screen/nft_screen.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 450);

  _onChanged(String input) {
    if (input.isNotEmpty) {
      _debouncer.run(() {
        Provider.of<SearchProvider>(context, listen: false).search(input);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: space2x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: rh(60)),
          CustomTextFormField(
            controller: _searchController,
            isAutoFocused: true,
            labelText: 'Search Collection and Nfts',
            validator: validator,
            onChanged: _onChanged,
            suffix: Buttons.icon(
              icon: Icons.close,
              size: rf(16),
              onPressed: () => _searchController.clear(),
              context: context,
              top: 0,
              bottom: 0,
              left: 12,
              semanticLabel: 'Close',
            ),
          ),
          SizedBox(height: rh(space4x)),
          Expanded(
            child: SingleChildScrollView(
              child:
                  Consumer<FavProvider>(builder: (context, favProvider, child) {
                return Consumer<SearchProvider>(
                  builder: (context, provider, child) {
                    if (provider.state == SearchState.loading) {
                      return const LoadingIndicator();
                    } else if (provider.collectionResults.isEmpty &&
                        provider.nftResults.isEmpty) {
                      return const EmptyWidget(text: 'No results');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (provider.collectionResults.isNotEmpty)
                          _CollectionWidget(
                            collections: provider.collectionResults,
                            favProvider: favProvider,
                            provider: provider,
                          ),
                        if (provider.nftResults.isNotEmpty)
                          _CollectionWidget(
                            nfts: provider.nftResults,
                            favProvider: favProvider,
                            provider: provider,
                          ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionWidget extends StatelessWidget {
  const _CollectionWidget({
    Key? key,
    required this.favProvider,
    required this.provider,
    this.nfts,
    this.collections,
  }) : super(key: key);

  final FavProvider favProvider;
  final SearchProvider provider;
  final List<NFT>? nfts;
  final List<Collection>? collections;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        UpperCaseText(
          collections == null ? 'NFTs' : 'Collections',
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: rh(space3x)),
        ListView.separated(
          itemCount: collections == null ? nfts!.length : collections!.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: rh(space2x));
          },
          itemBuilder: (BuildContext context, int index) {
            if (collections != null) {
              final collection = collections![index];
              return GestureDetector(
                onTap: () => Navigation.push(
                  context,
                  screen: CollectionScreen(collection: collection),
                ),
                child: CollectionListTile(
                  image: collection.image,
                  title: collection.name,
                  subtitle: 'By ${formatAddress(collection.creator)}',
                  isFav: favProvider.isFavCollection(collection),
                  onFavPressed: () => favProvider.setFavCollection(collection),
                ),
              );
            } else {
              final nft = nfts![index];

              return NFTCard(
                onTap: () =>
                    Navigation.push(context, screen: NFTScreen(nft: nft)),
                heroTag: '${nft.cAddress}-${nft.tokenId}',
                image: nft.image,
                title: nft.name,
                subtitle: nft.cName,
                isFav: favProvider.isFavNFT(nft),
                onFavPressed: () => favProvider.setFavNFT(nft),
              );
            }
          },
        ),
        SizedBox(height: rh(space2x)),
        const Divider(),
        SizedBox(height: rh(space2x)),
      ],
    );
  }
}
