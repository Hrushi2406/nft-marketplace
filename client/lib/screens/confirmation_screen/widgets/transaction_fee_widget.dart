import 'package:flutter/material.dart';
import 'package:nfts/core/services/gasprice_service.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/core/widgets/custom_widgets.dart';
import 'package:web3dart/web3dart.dart';

class TransactionFeeWidget extends StatelessWidget {
  const TransactionFeeWidget({
    Key? key,
    required this.transactionInfo,
    required this.gasInfo,
    required this.totalAmount,
  }) : super(key: key);

  final Transaction transactionInfo;
  final GasInfo gasInfo;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (transactionInfo.value != null)
          BidTile(
            text: 'Transaction Amount',
            value: '${transactionInfo.value!.getInEther} MAT',
            isFontRegular: true,
          ),
        if (transactionInfo.value != null) SizedBox(height: rh(space3x)),
        BidTile(
          text: 'Estimated Gas Fee',
          value: '${gasInfo.totalGasRequired} MAT',
          isFontRegular: true,
        ),
        SizedBox(height: rh(space2x)),
        const Divider(color: Colors.black87),
        SizedBox(height: rh(space2x)),
        BidTile(
          text: 'Total',
          value: '$totalAmount MAT',
          isFontRegular: true,
        ),
      ],
    );
  }
}