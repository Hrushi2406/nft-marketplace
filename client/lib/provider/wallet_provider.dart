import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nfts/core/services/contract_service.dart';
import 'package:nfts/core/services/gasprice_service.dart';
import 'package:web3dart/web3dart.dart';

import '../core/services/wallet_service.dart';

enum WalletState { empty, loading, loaded, success, error, logOut }

class WalletProvider with ChangeNotifier {
  final WalletService _walletService;
  final Web3Client _client;
  final GasPriceService _gasPriceService;
  final ContractService _contractService;

  WalletProvider(
    this._walletService,
    this._client,
    this._gasPriceService,
    this._contractService,
  );

  WalletState state = WalletState.empty;
  String errMessage = '';

  late Credentials cred;
  late EthereumAddress address;
  EtherAmount? balance;

  //Transaction Specific
  GasInfo? gasInfo;
  Transaction? transactionInfo;
  double totalAmount = 0;
  String lastTxHash = '';

  //Transaction Async
  Function? onNetworkConfirmationRun;

  getBalance() async {
    balance = await _client.getBalance(address);
    _handleLoaded();
  }

  //Get Transaction Cost
  getTransactionFee(Transaction transaction) async {
    try {
      transactionInfo = transaction;
      gasInfo = null;

      _handleLoading();

      gasInfo = null;

      gasInfo = await _gasPriceService.getGasInfo(transaction);

      if (transactionInfo!.value == null) {
        totalAmount = gasInfo!.totalGasRequired;
      } else {
        totalAmount = gasInfo!.totalGasRequired +
            transactionInfo!.value!.getValueInUnit(EtherUnit.ether);
      }

      getBalance();
    } catch (e) {
      debugPrint('Error at WallerProvider -> GetTransactionFee: $e');
    }
  }

  sendTransaction(Transaction transaction) async {
    debugPrint('Sending transaction');
    try {
      _handleLoading();

      lastTxHash = '';
      lastTxHash = await _client.sendTransaction(
        cred,
        transaction,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      debugPrint('Transaction completed $lastTxHash');

      getBalance();
      _handleSuccess();

      return;
    } catch (e) {
      debugPrint('Error at WalletProvider -> sendTransaction: $e');

      _handleError(e);
    }
  }

  buildTransaction(String contractAddress, String fName, List<dynamic> args,
      [double? value]) async {
    final contract =
        await _contractService.loadCollectionContract(contractAddress);

    final transaction = Transaction.callContract(
      from: address,
      contract: contract,
      value: value == null
          ? null
          : EtherAmount.fromUnitAndValue(
              EtherUnit.gwei,
              BigInt.from(value * pow(10, 9)),
            ),
      function: contract.function(fName),
      parameters: args,
    );

    getTransactionFee(transaction);
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
