import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../config/config.dart';
import '../models/collection.dart';
import '../models/nft.dart';
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
    final key = _prefs.getString('user_private_key')!;

    final collections =
        jsonDecode(_prefs.getString(key + '-' + kFavCollection) ?? '[]');
    final nfts = jsonDecode(_prefs.getString(key + '-' + kFavNFT) ?? '[]');

    favCollections =
        collections.map<Collection>((c) => Collection.fromJson(c)).toList();

    favNFT = nfts.map<NFT>((n) => NFT.fromJson(n)).toList();

    notifyListeners();
  }

  setFavCollection(Collection collection) async {
    final key = _prefs.getString('user_private_key')!;

    if (isFavCollection(collection)) {
      favCollections.remove(collection);
    } else {
      favCollections.add(collection);
    }
    //Encode and save
    await _prefs.setString(
        key + '-' + kFavCollection, jsonEncode(favCollections));

    notifyListeners();
  }

  setFavNFT(NFT nft) async {
    final key = _prefs.getString('user_private_key')!;
    //Add
    if (isFavNFT(nft)) {
      favNFT.remove(nft);
    } else {
      favNFT.add(nft);
    }
    //Encode and save
    await _prefs.setString(key + '-' + kFavNFT, jsonEncode(favNFT));

    notifyListeners();
  }
}
