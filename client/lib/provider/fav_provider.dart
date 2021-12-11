import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nfts/config/config.dart';
import 'package:nfts/models/collection.dart';
import 'package:nfts/models/nft.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FavState { empty, loading, loaded, success, error }

class FavProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  FavProvider(this._prefs);

  FavState state = FavState.empty;
  String errMessage = '';
  //state variables
  List<Collection> favCollections = [];
  List<NFT> favNFT = [];

  bool isFavNFT(NFT nft) => favNFT.contains(nft);
  bool isFavCollection(Collection collection) =>
      favCollections.contains(collection);

  fetchFav() {
    final collections = jsonDecode(_prefs.getString(kFavCollection) ?? '[]');
    final nfts = jsonDecode(_prefs.getString(kFavNFT) ?? '[]');

    favCollections =
        collections.map<Collection>((c) => Collection.fromJson(c)).toList();

    favNFT = nfts.map<NFT>((n) => NFT.fromJson(n)).toList();

    notifyListeners();
  }

  setFavCollection(Collection collection) async {
    if (isFavCollection(collection)) {
      favCollections.remove(collection);
    } else {
      favCollections.add(collection);
    }
    //Encode and save
    await _prefs.setString(kFavCollection, jsonEncode(favCollections));

    notifyListeners();
  }

  setFavNFT(NFT nft) async {
    //Add
    if (isFavNFT(nft)) {
      favNFT.remove(nft);
    } else {
      favNFT.add(nft);
    }
    //Encode and save
    await _prefs.setString(kFavNFT, jsonEncode(favNFT));

    notifyListeners();
  }
}
