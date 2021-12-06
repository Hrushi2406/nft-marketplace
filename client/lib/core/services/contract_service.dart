import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../../config/config.dart';

class ContractService {
  late final DeployedContract collection;
  late final DeployedContract marketPlace;

  ContractService() {
    _init();
  }

  Future<void> _init() async {
    //collection
    collection = await _loadABI(
      'assets/abi/Marketplace.json',
      'Marketplace',
      marketPlaceAddress,
    );

    //Marketplace
    marketPlace = await _loadABI(
      'assets/abi/Marketplace.json',
      'Marketplace',
      marketPlaceAddress,
    );
  }

  Future<DeployedContract> _loadABI(
    String path,
    String name,
    String contractAddress,
  ) async {
    String abiString = await rootBundle.loadString(path);

    final abiJson = jsonDecode(abiString);

    final abi = jsonEncode(abiJson['abi']);

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, name),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }
}
