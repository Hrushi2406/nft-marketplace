import 'package:flutter/foundation.dart';
import '../config/gql_query.dart';
import '../core/services/graphql_service.dart';
import '../models/collection.dart';
import '../models/nft.dart';
import '../models/user.dart';

enum SearchState { empty, loading, loaded, success, error }

class SearchProvider with ChangeNotifier {
  final GraphqlService _graphql;

  SearchProvider(this._graphql);

  SearchState state = SearchState.empty;
  String errMessage = '';

  //State varaibles
  List<User> userResults = [];
  List<Collection> collectionResults = [];
  List<NFT> nftResults = [];

  search(String input) async {
    try {
      Map<String, dynamic> data = {
        'collections': [],
        'nfts': [],
        'users': [],
      };

      _handleLoading();

      if (_isInputAddress(input)) {
        data = await _graphql.get(qSearchAddress, {'address': input});
      } else {
        data = await _graphql.get(qSearchName, {'name': input});
      }

      collectionResults = data['collections']
          .map<Collection>((c) => Collection.fromMap(c))
          .toList();

      nftResults = data['nfts'].map<NFT>((c) => NFT.fromMap(c)).toList();

      userResults = data['users'].map<User>((u) => User.fromMap(u)).toList();

      _handleLoaded();
    } catch (e) {
      debugPrint('Error at SearchProvider -> search: $e');

      _handleError(e);
    }
  }

  bool _isInputAddress(String input) {
    return input.startsWith('0x') && input.length.isEven;
  }

  void _handleEmpty() {
    state = SearchState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = SearchState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = SearchState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = SearchState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = SearchState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
