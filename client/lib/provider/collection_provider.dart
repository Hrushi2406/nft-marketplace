import 'package:flutter/foundation.dart';

enum CollectionState { empty, loading, loaded, success, error }

class CollectionProvider with ChangeNotifier {
  CollectionState state = CollectionState.empty;
  String errMessage = '';

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
