import 'package:flutter/foundation.dart';
import 'package:nfts/config/gql_query.dart';
import 'package:nfts/core/services/graphql_service.dart';
import 'package:nfts/core/services/ipfs_service.dart';
import 'package:nfts/models/nft.dart';
import 'package:nfts/models/nft_activity.dart';
import 'package:nfts/models/nft_metadata.dart';

enum NFTState { empty, loading, loaded, success, error }

class NFTProvider with ChangeNotifier {
  final GraphqlService _graphql;
  final IPFSService _ipfs;

  NFTProvider(this._graphql, this._ipfs);

  //State variables
  NFTState state = NFTState.empty;
  String errMessage = '';

  //Vairables
  NFTMetadata metadata = NFTMetadata.initEmpty();
  List<NFTActivity> activities = [];

  fetchNFTMetadata(NFT nft) async {
    try {
      final stopWatch = Stopwatch();
      stopWatch.start();

      state = NFTState.loading;

      //reset State
      metadata = NFTMetadata.initEmpty();
      activities.clear();

      final gData = await _graphql.get(qNFT, {
        'cAddress': nft.cAddress,
        'tokenId': nft.tokenId,
        'creator': nft.creator,
      });

      ///NFT Activity of Buying selling
      activities = gData['nftevents']
          .map<NFTActivity>((activity) => NFTActivity.fromMap(activity))
          .toList();

      _handleLoaded();

      final data = await _ipfs.getJson(nft.metadata);

      metadata = NFTMetadata.fromMap(data);

      print(stopWatch.elapsed);

      notifyListeners();
    } catch (e) {
      debugPrint('Error at CollectionProvider -> fetchCollectionMeta: $e');

      _handleError(e);
    }
  }

  void _handleEmpty() {
    state = NFTState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = NFTState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = NFTState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = NFTState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = NFTState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
