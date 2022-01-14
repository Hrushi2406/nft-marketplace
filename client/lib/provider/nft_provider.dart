import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';

import '../config/functions.dart';
import '../config/gql_query.dart';
import '../core/services/contract_service.dart';
import '../core/services/graphql_service.dart';
import '../core/services/ipfs_service.dart';
import '../core/services/nft_repo.dart';
import '../core/utils/utils.dart';
import '../models/bid.dart';
import '../models/collection.dart';
import '../models/listing_info.dart';
import '../models/nft.dart';
import '../models/nft_activity.dart';
import '../models/nft_metadata.dart';
import 'collection_provider.dart';
import 'user_provider.dart';
import 'wallet_provider.dart';

enum NFTState { empty, loading, loaded, success, error }

class NFTProvider with ChangeNotifier {
  final GraphqlService _graphql;
  final IPFSService _ipfs;
  final ContractService _contractService;
  final WalletProvider _walletProvider;
  final CollectionProvider _collectionProvider;
  final UserProvider _userProvider;
  final NFTRepo _repo;

  NFTProvider(
    this._graphql,
    this._ipfs,
    this._contractService,
    this._walletProvider,
    this._collectionProvider,
    this._repo,
    this._userProvider,
  );

  //State variables
  NFTState state = NFTState.empty;
  String errMessage = '';

  //Vairables
  NFTMetadata metadata = NFTMetadata.initEmpty();
  List<NFTActivity> activities = [];
  ListingInfo? listingInfo;
  List<Bid> bids = [];
  Collection? nftCollection;

  //ADD VARIABLES
  List<Map<String, dynamic>> properties = [];
  String royalties = '0';
  ListingType _listingType = ListingType.fixedPriceSale;
  ListingType get listingType => _listingType;
  set listingType(ListingType type) {
    _listingType = type;
    notifyListeners();
  }

  Bid? _selectedBid;
  Bid? get selectedBid => _selectedBid;
  set selectedBid(Bid? bid) {
    _selectedBid = bid;
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

      // _userProvider.fetchUserInfo();

      _collectionProvider.fetchCollectionMeta(collection);

      _handleSuccess();
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

    final price = info.price * pow(10, 18);

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
        BigInt.from(price),
        BigInt.from(info.royalties),
        //UNLOCKABLE CONTENT
        '',
      ],
    );

    return transaction;
  }

  getPlaceBidFee(NFT nft, double biddingPrice) async {
    try {
      final contract =
          await _contractService.loadCollectionContract(nft.cAddress);

      final data = const ContractFunction(
        fplaceBid,
        [
          FunctionParameter('tokenId', UintType()),
        ],
      ).encodeCall([
        BigInt.from(nft.tokenId),
      ]);

      final transaction = Transaction(
        from: _walletProvider.address,
        to: contract.address,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        data: data,
      );
      // print(transaction.value!.getInWei.toString().length);

      // final transaction = Transaction.callContract(
      //   from: _walletProvider.address,
      //   contract: contract,
      //   function: contract.function(fbuyFixedPriceNFT),
      //   value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 2),
      //   parameters: [
      //     BigInt.from(nft.tokenId),
      //     //UNLOCKABLE CONTENT
      //   ],
      // );

      // final transaction = Transaction.callContract(
      //   from: _walletProvider.address,
      //   contract: contract,
      //   function: contract.function(fplaceBid),
      //   value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),

      //   // value: EtherAmount.inWei(price * BigInt.from(1000000000000)),
      //   // value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 10),
      //   // value: EtherAmount.inWei(BigInt.from(price)),

      //   // BigInt.from(price),
      //   parameters: [BigInt.from(nft.tokenId)],
      // );

      // print(transaction.value!.getInWei.toString().length);

      await _walletProvider.getTransactionFee(transaction);
      // await _walletProvider.sendTransaction(transaction);

    } catch (e) {
      debugPrint('Error at NFTProvider->placebid: $e');

      _handleError(e);
    }
  }

  placeBid(Transaction transaction) async {
    try {
      await _walletProvider.sendTransaction(transaction);
    } catch (e) {
      debugPrint('Error at NFTProvider->PlaceBid: $e');
      _handleError(e);
    }
  }

  fetchNFTMetadata(NFT nft) async {
    try {
      state = NFTState.loading;

      //reset State
      metadata = NFTMetadata.initEmpty();
      listingInfo = null;
      bids.clear();
      nftCollection = null;
      activities.clear();
      _selectedBid = null;

      final gData = await _graphql.get(qNFT, {
        'cAddress': nft.cAddress,
        'tokenId': nft.tokenId,
        'creator': nft.creator,
      });

      listingInfo = await _repo.getNFTListingInfo(nft.cAddress, nft.tokenId);

      listingType = listingInfo!.listingType;
      nftCollection = Collection.fromMap(gData['collections'][0]);

      ///NFT Activity of Buying selling
      activities = gData['nftevents']
          .map<NFTActivity>((activity) => NFTActivity.fromMap(activity))
          .toList();

      bids = gData['bids'].map<Bid>((bid) => Bid.fromMap(bid)).toList();

      //sort bids by price
      bids.sort((a, b) => b.price.compareTo(a.price));

      if (bids.isNotEmpty) _selectedBid = bids[0];

      _handleLoaded();

      final data = await _ipfs.getJson(nft.metadata);

      metadata = NFTMetadata.fromMap(data);

      // activities = activities.reversed.toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error at NFTProvider -> fetchNFTMeta: $e');

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
