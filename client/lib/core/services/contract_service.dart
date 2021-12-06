import 'dart:convert';

import 'package:web3dart/web3dart.dart';

class ContractService {
  final Web3Client client;

  ContractService(this.client);

  get() async {
    final c = DeployedContract(
      ContractAbi.fromJson(jsonEncode({'as': 'asdf'}), 'asdf'),
      EthereumAddress.fromHex('as'),
    );

    // c.event(name);
    // client.sendTransaction(cred, transaction);
    final transaction = Transaction.callContract(
      contract: c,
      function: c.function('a'),
      parameters: [],
    );
    await client.call(contract: c, function: c.function(''), params: []);
    // cli
  }

  // final owne

  // final

  // send() {}

  // get(String name, List<dynamic> args) {
  // client.call(contract: c, function: c.fun, params: params)
  // }
}
