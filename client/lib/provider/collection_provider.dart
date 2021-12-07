import 'package:flutter/foundation.dart';

import '../config/gql_query.dart';
import '../core/services/graphql_service.dart';
import '../core/services/ipfs_service.dart';
import '../models/collection.dart';
import '../models/collection_metadata.dart';
import '../models/nft.dart';

enum CollectionState { empty, loading, loaded, success, error }

class CollectionProvider with ChangeNotifier {
  final IPFSService _ipfs;
  final GraphqlService _graphql;

  CollectionProvider(this._ipfs, this._graphql);

  CollectionState state = CollectionState.empty;
  String errMessage = '';

  //Variables
  List<NFT> collectionItems = [];
  CollectionMetaData metaData = CollectionMetaData.initEmpty();

  //TODO :Check colletion on opean sea 0x5ee04c97881eb4da8892b209c8baad55c3c17b30

  fetchCollectionMeta(Collection collection) async {
    try {
      state = CollectionState.loading;
      //reset State
      metaData = CollectionMetaData.initEmpty();
      collectionItems.clear();

      final gData = await _graphql.get(qCollection, {
        'cAddress': collection.cAddress,
        'creator': collection.creator,
      });

      //Collection Items
      collectionItems =
          gData['nfts'].map<NFT>((nft) => NFT.fromMap(nft)).toList();

      _handleLoaded();

      final stopWatch = Stopwatch();
      stopWatch.start();

      final data = await _ipfs.getJson(collection.metadata);

      metaData = CollectionMetaData.fromMap(data);

      print(stopWatch.elapsed);

      notifyListeners();
    } catch (e) {
      debugPrint('Error at CollectionProvider -> fetchCollectionMeta: $e');

      _handleError(e);
    }
  }

  void _handleEmpty() {
    state = CollectionState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = CollectionState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = CollectionState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = CollectionState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = CollectionState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
