import 'package:flutter/foundation.dart';

enum CreatorState { empty, loading, loaded, success, error }

class CreatorProvider with ChangeNotifier {
  CreatorState state = CreatorState.empty;
  String errMessage = '';

  fetchCreator(String address) async {
    //GRAPQL SERIVCE
    //ON CHAIN
  }

  void _handleEmpty() {
    state = CreatorState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = CreatorState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = CreatorState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = CreatorState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = CreatorState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
