import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';

import '../config/gql_query.dart';
import '../core/services/graphql_service.dart';
import '../models/collection.dart';
import '../models/nft.dart';
import '../models/user.dart';
import 'wallet_provider.dart';

enum CreatorState { empty, loading, loaded, success, error }

class CreatorProvider with ChangeNotifier {
  final GraphqlService _graphql;
  final WalletProvider _walletProvider;

  CreatorProvider(this._graphql, this._walletProvider);

  CreatorState state = CreatorState.empty;
  String errMessage = '';

  ///VARAIBLES
  User? user;

  List<Collection> createdCollections = [];
  List<NFT> collectedNFTs = [];
  List<NFT> singles = [];

  fetchCreatorInfo(EthereumAddress address) async {
    _handleLoading();

    final data = await _graphql.get(qCreator, {'uAddress': address.hex});

    if (data['users'].isEmpty) {
      user = User(
        name: 'Unamed',
        uAddress: address,
        metadata: '',
        image: 'bafybeid3njd5agpz7a3mloo3q5cdcmtvo7o3uab6hhwongfck23ycv3uyy',
      );
    } else {
      user = User.fromMap(data['users'][0]);

      createdCollections = data['collections']
          .map<Collection>((collection) => Collection.fromMap(collection))
          .toList();

      //TODO: Change Singles logic
      singles = data['nfts'].map<NFT>((nft) => NFT.fromMap(nft)).toList();

      collectedNFTs = data['nfts'].map<NFT>((nft) => NFT.fromMap(nft)).toList();
    }

    _handleLoaded();
  }

  // fetchCreator(String address) async {
  //   //GRAPQL SERIVCE

  //   //ON CHAIN
  // }

  void _handleEmpty() {
    state = CreatorState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = CreatorState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = CreatorState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = CreatorState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = CreatorState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
