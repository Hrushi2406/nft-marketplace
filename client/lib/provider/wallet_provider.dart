import 'package:flutter/foundation.dart';

enum WalletState { empty, loading, loaded, success, error }

class WalletProvider with ChangeNotifier {
  WalletState state = WalletState.empty;
  String errMessage = '';

  // getGasPrice() async{}

  generateRandomKey() async {}

  void _handleEmpty() {
    state = WalletState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = WalletState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = WalletState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = WalletState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = WalletState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
