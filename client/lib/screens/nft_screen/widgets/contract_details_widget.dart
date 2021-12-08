import 'package:flutter/material.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:nfts/models/nft.dart';

class ContractDetailsWidget extends StatelessWidget {
  const ContractDetailsWidget({Key? key, required this.nft}) : super(key: key);

  final NFT nft;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UpperCaseText(
          'Contract Details',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: rh(space3x)),
        DataTile(
          label: 'Contract Address',
          value: nft.cAddress,
        ),
        SizedBox(height: rh(space2x)),
        DataTile(
          label: 'Token id',
          value: nft.tokenId.toString(),
        ),
        SizedBox(height: rh(space2x)),
        const DataTile(
          label: 'Token Standard',
          value: 'ERC 721',
        ),
        SizedBox(height: rh(space2x)),
        const DataTile(
          label: 'Blockchain',
          value: 'Polygon',
        ),
      ],
    );
  }
}
