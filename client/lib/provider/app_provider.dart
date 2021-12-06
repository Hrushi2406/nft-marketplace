import 'package:flutter/foundation.dart';

enum AppState { empty, loading, loaded, success, error, unauthenticated }

class AppProvider with ChangeNotifier {
  AppState state = AppState.empty;
  String errMessage = '';

  fetchInitialData() async {
    // USING GRAPQL SERVICE
    //TABS SCREEN DATA
  }

  void _handleEmpty() {
    state = AppState.empty;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoading() {
    state = AppState.loading;
    errMessage = '';
    notifyListeners();
  }

  void _handleLoaded() {
    state = AppState.loaded;
    errMessage = '';
    notifyListeners();
  }

  void _handleSuccess() {
    state = AppState.success;
    errMessage = '';
    notifyListeners();
  }

  void _handleError(e) {
    state = AppState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
