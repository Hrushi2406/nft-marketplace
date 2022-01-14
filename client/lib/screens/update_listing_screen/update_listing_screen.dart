import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_widgets.dart';
import '../../models/nft.dart';
import '../../models/nft_metadata.dart';

class UpdateListingScreen extends StatefulWidget {
  const UpdateListingScreen({
    Key? key,
    this.isUpdate = true,
    this.nftMetadata,
    this.nft,
  }) : super(key: key);

  final bool isUpdate;
  final NFTMetadata? nftMetadata;
  final NFT? nft;

  @override
  _UpdateListingScreenState createState() => _UpdateListingScreenState();
}

class _UpdateListingScreenState extends State<UpdateListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CustomAppBar(),
            SizedBox(height: rh(space4x)),
            CollectionListTile(
              image: widget.nftMetadata!.image,
              title: widget.nftMetadata!.name,
              subtitle: '',
              // isFav: favProvider.isFavCollection(collection),
              // onFavPressed: () => favProvider.setFavCollection(collection),
            ),
          ],
        ),
      ),
    );
  }
}
