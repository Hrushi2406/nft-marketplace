import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/models/collection.dart';
import 'package:nfts/provider/creator_provider.dart';
import 'package:nfts/provider/nft_provider.dart';
import 'package:nfts/provider/wallet_provider.dart';
import 'package:provider/provider.dart';

class ChooseCollectionWidget extends StatefulWidget {
  const ChooseCollectionWidget({Key? key, required this.selectCollection})
      : super(key: key);

  final Function selectCollection;

  @override
  State<ChooseCollectionWidget> createState() => _ChooseCollectionWidgetState();
}

class _ChooseCollectionWidgetState extends State<ChooseCollectionWidget> {
  _selectCollection(Collection collection) {
    widget.selectCollection(collection);

    Navigation.pop(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<CreatorProvider>(context, listen: false)
        .fetchCurrentUserCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80 * rHeightMultiplier,
      padding: const EdgeInsets.symmetric(horizontal: space2x),
      child: Consumer<CreatorProvider>(builder: (context, provider, child) {
        if (provider.state == CreatorState.loading) {
          return const LoadingIndicator();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: rh(space3x)),
            Center(
              child: UpperCaseText(
                'Choose Collection',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: rh(space3x)),

            //List
            Expanded(
              child: ListView.separated(
                itemCount: provider.userCollections.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: rh(space3x));
                },
                itemBuilder: (BuildContext context, int index) {
                  final collection = provider.userCollections[index];
                  return GestureDetector(
                    onTap: () => _selectCollection(collection),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          UpperCaseText(
                            collection.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Icon(Icons.check, size: rf(space2x)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
