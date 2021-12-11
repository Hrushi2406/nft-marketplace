import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletService {
  final SharedPreferences _prefs;

  WalletService(this._prefs);

  //GENERATE RANDOM WALLET
  Credentials generateRandomAccount() {
    // print(Random.secure());
    final cred = EthPrivateKey.createRandom(Random.secure());

    final key = bytesToHex(
      cred.privateKey,
      padToEvenLength: true,
    );

    setPrivateKey(key);

    return cred;
  }

  ///Retrieve cred from private key
  Credentials initalizeWallet([String? key]) =>
      EthPrivateKey.fromHex(key ?? getPrivateKey());

  ///Retrieve Private key from prefs
  ///If not present send empty
  String getPrivateKey() => _prefs.getString('user_private_key') ?? '';

  ///set private key
  Future<void> setPrivateKey(String value) async =>
      await _prefs.setString('user_private_key', value);
}
