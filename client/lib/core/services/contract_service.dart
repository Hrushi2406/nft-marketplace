import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../../config/config.dart';

class ContractService {
  late final DeployedContract collection;
  late final DeployedContract marketPlace;
  late final DeployedContract priceFeed;

  ContractService() {
    _init();
  }

  Future<void> _init() async {
    //collection
    collection = await _loadABI(
      'assets/abi/CustomCollection.json',
      'CustomCollection',
      customERC721Address,
    );

    priceFeed = await _loadABI(
      'assets/abi/PriceFeed.json',
      'PriceFeed',
      priceFeedAddress,
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

    // final abiJson = jsonDecode(abiString);

    // final abi = jsonEncode(abiJson['abi']);

    final contract = DeployedContract(
      ContractAbi.fromJson(abiString, name),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

//Load Collection Contract on the go
  Future<DeployedContract> loadCollectionContract(
    String contractAddress,
  ) async =>
      await _loadABI(
        'assets/abi/CustomCollection.json',
        'CustomERC721Collection',
        contractAddress,
      );
}
