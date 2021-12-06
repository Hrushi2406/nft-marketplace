import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';

import '../core/services/wallet_service.dart';

enum WalletState { empty, loading, loaded, success, error, logOut }

class WalletProvider with ChangeNotifier {
  final WalletService _walletService;
  final Web3Client client;

  WalletProvider(this._walletService, this.client);

  WalletState state = WalletState.empty;
  String errMessage = '';

  late Credentials cred;
  late EthereumAddress address;
  EtherAmount? balance;

  // fetchBalance() =>

  getBalance() async {
    balance = await client.getBalance(address);
    _handleLoaded();
  }

  initializeWallet() async {
    cred = _walletService.initalizeWallet();
    address = await cred.extractAddress();
    getBalance();

    _handleLoaded();
  }

  initializeFromKey(String privateKey) async {
    try {
      cred = _walletService.initalizeWallet(privateKey);
      address = await cred.extractAddress();
      await _walletService.setPrivateKey(privateKey);
      getBalance();

      _handleSuccess();
    } on FormatException catch (e) {
      debugPrint('Error: ${e.message}');

      _handleError('Invalid private key');
    } catch (e) {
      debugPrint('Error: $e');

      _handleError(e);
    }
  }

  createWallet() async {
    _handleLoading();
    cred = _walletService.generateRandomAccount();
    address = await cred.extractAddress();
    getBalance();

    _handleSuccess();
  }

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
    Timer(const Duration(milliseconds: 450), _handleEmpty);
  }

  void _handleError(e) {
    state = WalletState.error;
    errMessage = e.toString();
    notifyListeners();
  }
}
