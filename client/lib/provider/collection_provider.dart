import 'package:flutter/foundation.dart';
import 'package:nfts/core/services/contract_service.dart';
import 'package:nfts/core/services/gasprice_service.dart';
import 'package:web3dart/web3dart.dart';

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
  final GasPriceService _gasPriceService;
  final ContractService _contractService;

  CollectionProvider(
      this._ipfs, this._graphql, this._gasPriceService, this._contractService);

  CollectionState state = CollectionState.empty;
  String errMessage = '';

  //Variables
  List<NFT> collectionItems = [];
  CollectionMetaData metaData = CollectionMetaData.initEmpty();

  String? imageCID;
  String? metadataCID;

  //Upload image to ipfs and store cid
  uploadImage(String imgPath) async {
    try {
      imageCID = null;

      imageCID = await _ipfs.uploadImage(imgPath);

      print('Uploaded Imaeg');
    } catch (e) {
      debugPrint('Error at CollectionProvider -> uploadImage: $e');

      _handleError(e);
    }
  }

  //Upload metadata to ipfs and store cid
  uploadMetadata(CollectionMetaData metaDataWithoutImage) async {
    try {
      _handleLoading();
      metadataCID = null;

      if (imageCID == null) {
        await Future.delayed(const Duration(milliseconds: 450));
        uploadMetadata(metaDataWithoutImage);
        return;
      }

      final metaData = metaDataWithoutImage.copyWith(image: imageCID);

      metadataCID = await _ipfs.uploadMetaData(metaData.toMap());

      print('Uploaded Metadata');

      _handleSuccess();

      // print('')
    } catch (e) {
      debugPrint('Error at CollectionProvider -> uploadMetadata: $e');

      _handleError(e);
    }
  }

  getGasFee(String cAddress) async {
    try {
      final contract = await _contractService.loadCollectionContract(cAddress);

// _web3Client.

      // final transaction = Transaction.callContract(contract: contract, function: contract.function(f) parameters: parameters,);

      // final gasInfo = await _gasPriceService.getGasInfo(transaction);
    } catch (e) {
      debugPrint('Error at CollectionProvider -> getGasFee: $e');

      _handleError(e);
    }
  }

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
