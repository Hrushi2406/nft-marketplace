import 'package:flutter/foundation.dart';
import 'package:nfts/config/functions.dart';
import 'package:nfts/config/gql_query.dart';
import 'package:nfts/core/services/contract_service.dart';
import 'package:nfts/core/services/graphql_service.dart';
import 'package:nfts/core/services/ipfs_service.dart';
import 'package:nfts/core/utils/utils.dart';
import 'package:nfts/models/collection.dart';
import 'package:nfts/models/listing_info.dart';
import 'package:nfts/models/nft.dart';
import 'package:nfts/models/nft_activity.dart';
import 'package:nfts/models/nft_metadata.dart';
import 'package:nfts/provider/collection_provider.dart';
import 'package:nfts/provider/creator_provider.dart';
import 'package:nfts/provider/wallet_provider.dart';
import 'package:web3dart/web3dart.dart';

enum NFTState { empty, loading, loaded, success, error }

class NFTProvider with ChangeNotifier {
  final GraphqlService _graphql;
  final IPFSService _ipfs;
  final ContractService _contractService;
  final WalletProvider _walletProvider;
  final CollectionProvider _collectionProvider;

  NFTProvider(
    this._graphql,
    this._ipfs,
    this._contractService,
    this._walletProvider,
    this._collectionProvider,
  );

  //State variables
  NFTState state = NFTState.empty;
  String errMessage = '';

  //Vairables
  NFTMetadata metadata = NFTMetadata.initEmpty();
  List<NFTActivity> activities = [];

  //ADD VARIABLES
  List<Map<String, dynamic>> properties = [];
  String royalties = '0';
  ListingType _listingType = ListingType.fixedPriceSale;
  ListingType get listingType => _listingType;
  set listingType(ListingType type) {
    _listingType = type;
    notifyListeners();
  }

  String? imageCID;
  String? metadataCID;

  NFTMetadata nftToMint = NFTMetadata.initEmpty();

  //TO QUE REQUESTS
  List<int> uploadImageQue = [];
  List<int> uploadMetadataQue = [];

  //Upload image to ipfs and store cid
  uploadImage(String imgPath) async {
    try {
      print('uploading image');
      //Add the request to que
      uploadImageQue.add(1);

      imageCID = null;

      imageCID = await _ipfs.uploadImage(imgPath);

      //Remove request from que
      uploadImageQue.removeLast();
    } catch (e) {
      debugPrint('Error at NFTProvider -> uploadImage: $e');

      //Remove request from que
      uploadImageQue.removeLast();

      _handleError(e);
    }
  }

  //Upload metadata to ipfs and store cid
  uploadMetadata(NFTMetadata metaDataWithoutImage,
      {bool isRecursive = false}) async {
    try {
      print('Called uploadMetaData');
      //Add request to que
      if (!isRecursive) {
        nftToMint = metaDataWithoutImage;
        uploadMetadataQue.add(1);
      }

      metadataCID = null;

      if (uploadImageQue.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 650));

        uploadMetadata(metaDataWithoutImage, isRecursive: true);
        return;
      }

      print('Uploading MetaData');

      nftToMint = metaDataWithoutImage.copyWith(image: imageCID);

      metadataCID = await _ipfs.uploadMetaData(nftToMint.toMap());

      //remove request from que
      uploadMetadataQue.removeLast();

      _handleSuccess();
    } catch (e) {
      debugPrint('Error at NFTProvider -> uploadMetadata: $e');

      //remove request from que
      uploadMetadataQue.removeLast();

      _handleError(e);
    }
  }

  mintNFT(ListingInfo listingInfo, Collection collection) async {
    try {
      _handleLoading();

      if (uploadMetadataQue.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 650));

        mintNFT(listingInfo, collection);
        return;
      }

      //send transaction
      final transaction = await buildTransaction(listingInfo, collection);

      await _walletProvider.sendTransaction(transaction);
      _clearState();

      _handleSuccess();

      _collectionProvider.fetchCollectionMeta(collection);
    } catch (e) {
      debugPrint('Error at NFTProvider -> mintNFT: $e');

      _handleError(e);
    }
  }

  _clearState() {
    imageCID = null;
    metadataCID = null;
    properties.clear();
    nftToMint = NFTMetadata.initEmpty();
    _listingType = ListingType.fixedPriceSale;
    royalties = '0';
  }

  Future<Transaction> buildTransaction(
    ListingInfo info,
    Collection collection,
  ) async {
    final contract =
        await _contractService.loadCollectionContract(collection.cAddress);
    final transaction = Transaction.callContract(
      from: _walletProvider.address,
      contract: contract,
      function: contract.function(fmintNFT),
      parameters: [
        nftToMint.name,
        //image
        imageCID ??
            'bafybeielrpyysfeos56qr2paenj5zmdamvry3rkyyzld4zua7xnpgeg3py',
        nftToMint.properties.toString(),
        //metadata
        metadataCID ??
            'bafybeicklz6kbzwhiqeedmlr42kjr6g5qjb5o5rq3fne4arhsvynzuywk4',
        info.forSale,
        info.isFixedPrice,
        BigInt.from(info.price),
        BigInt.from(info.royalties),
        //UNLOCKABLE CONTENT
        '',
      ],
    );

    return transaction;
  }

  // getTransactionFee(NFTMetadata nftMetadata, Collection collection) async {
  //   final contract =
  //       await _contractService.loadCollectionContract(collection.cAddress);

  //   final bool isForSale = _listingType == ListingType.fixedPriceSale;

  //   final bool isFixedPrice = _listingType == ListingType.fixedPriceSale ||
  //       _listingType == ListingType.fixedPriceNotSale;

  //   final transaction = Transaction.callContract(
  //     contract: contract,
  //     function: contract.function(fmintNFT),
  //     parameters: [
  //       nftMetadata.name,
  //       'bafybeielrpyysfeos56qr2paenj5zmdamvry3rkyyzld4zua7xnpgeg3py',
  //       nftMetadata.properties,
  //       //metadata
  //       'bafybeicklz6kbzwhiqeedmlr42kjr6g5qjb5o5rq3fne4arhsvynzuywk4',
  //       isForSale,
  //       isFixedPrice,

  //       // nftMetadata.image,
  //     ],
  //   );
  // }
  // getTransactionFee(NFTMetadata collection) {
  //   // final contract = _contractService.c;

  //   final transaction = Transaction.callContract(
  //     from: _walletProvider.address,
  //     contract: contract,
  //     function: contract.function(fcreateCollection),
  //     parameters: [
  //       collection.name,
  //       collection.symbol,
  //       // THIS WILL BE IMAGE
  //       'bafybeielrpyysfeos56qr2paenj5zmdamvry3rkyyzld4zua7xnpgeg3py',
  //       //THIS WILL BE METADATA
  //       'bafkreiggxphdigslrtq3d3qkgo65ohmggprsvcbqixxcodhpdzgn2ppxba',
  //     ],
  //   );

  //   _walletProvider.getTransactionFee(transaction);
  // }

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
      debugPrint('Error at NFTProvider -> fetchCollectionMeta: $e');

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
