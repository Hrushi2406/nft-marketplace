import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/custom_widgets.dart';
import 'package:web3dart/web3dart.dart';

class TransactionInfo extends StatelessWidget {
  const TransactionInfo({Key? key, required this.transactionInfo})
      : super(key: key);

  final Transaction transactionInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataTile(
          label: 'From',
          value: transactionInfo.from == null
              ? 'loading'
              : transactionInfo.from!.hex,
          isValueBold: false,
        ),
        SizedBox(height: rh(space3x)),
        Icon(
          Iconsax.arrow_down,
          size: rf(20),
        ),
        SizedBox(height: rh(space3x)),
        DataTile(
          label: 'To',
          value: transactionInfo.to!.hex,
          isValueBold: false,
        ),
        SizedBox(height: rh(space4x)),
        const Divider(),
        SizedBox(height: rh(space4x)),
      ],
    );
  }
}
