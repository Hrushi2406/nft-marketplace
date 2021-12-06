import 'dart:math';

import 'package:web3dart/web3dart.dart';

class WalletService {
  static generateRandomAccount() async {
    //Random Genereated
    final rng = Random.secure();

    Credentials credentials = EthPrivateKey.createRandom(rng);

    final address = await credentials.extractAddress();

    return address;
  }

  static Future<EthereumAddress> getPublicAddressFromKey(
      [String? privateKey]) async {
    Credentials credentials = EthPrivateKey.fromHex(
      "65f09c28414604a2dc3c78df732db52d4a4fe96007e05db407a729963ab3eb9e",
    );

    final address = await credentials.extractAddress();

    return address;
  }
}
