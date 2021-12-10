import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class GasPriceService {
  final Web3Client _web3client;
  final http.Client _httpClient;

  const GasPriceService(this._web3client, this._httpClient);

  ///Returns Gas Info
  ///
  ///for the transaction
  Future<GasInfo> getGasInfo(Transaction transaction) async {
    try {
      ///GET ESTIMATED GAS FOR TRANSACTION
      final estimatedGas = await _web3client.estimateGas(
        sender: transaction.from,
        to: transaction.to,
        value: transaction.value,
        data: transaction.data,
      );

      //Fetch current gas price
      final currentGasPrice = await _web3client.getGasPrice();

      final totalGasRequired =
          estimatedGas * currentGasPrice.getInWei / BigInt.from(10).pow(18);

      return GasInfo(
        gas: estimatedGas,
        currentGasPrice: currentGasPrice,
        totalGasRequired: totalGasRequired,
      );
    } catch (e) {
      debugPrint('Error at GasPriceService -> getGasInfo: $e');

      rethrow;
    }
  }

  ///RETURNS THE CURRENT GAS PRICE IN WEI
  ///
  ///FOR MATIC - 10^-18
  Future<BigInt> getCurrentGasPrice() async {
    //BODY PARAMETER FOR ETH GAS PRICE
    final body = {
      "jsonrpc": "2.0",
      "method": "eth_gasPrice",
      "params": [],
      "id": 1
    };

    try {
      //MAKE REQUEST TO MUMBAI TEST NET
      final response = await _httpClient.post(
        Uri.parse('https://rpc-mumbai.maticvigil.com/'),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      //EXTRACT VALUE WHICH IS IN HEX
      final amount = hexToInt(data['result']);

      return amount;
    } catch (e) {
      debugPrint('Error at Estimate Gas Price -> getCurrentGasPrice: $e');

      rethrow;
    }
  }
}

class GasInfo {
  ///Amount of gas required
  ///
  ///for the transaction
  final BigInt gas;

  ///Current Gas Price is in Wei
  ///
  ///For Matic - 10^-18
  final EtherAmount currentGasPrice;

  ///Final Gas Required in MAT
  ///
  ///gas*currentGasPrice / 10^-18
  ///
  ///
  final double totalGasRequired;

  const GasInfo({
    required this.gas,
    required this.currentGasPrice,
    required this.totalGasRequired,
  });

  @override
  String toString() {
    return 'GasInfo -> gas: $gas, currentGasPrice: $currentGasPrice, totalGasRequired: $totalGasRequired';
  }
}
