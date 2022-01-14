const NFTSTORAGEAPIKEY =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEVDY0FBMGRGYkI4QmQ5Nzc3MDYxNTdmZTMyQUUyYTU2MGNFMzkwZjgiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYzODcwODg0ODYxOSwibmFtZSI6Ik5GVCBNYXJrZXRwbGFjZSJ9.wtt_vDthKSl9FTLgLGSqMQhutD2hZ90Njijvfz0kHc4";

const GRPAHQL =
    'https://api.thegraph.com/subgraphs/name/sumit-mahajan/nft-marketplace/graphql';

// init() async {
//   final client = Web3Client(
//     'https://rpc-mumbai.maticvigil.com',
//     Client(),
//   );

//   final contractAddress =
//       // EthereumAddress.fromHex('0xb715C63EB20a32654BF7776bf270bd8eC443138a');
//       EthereumAddress.fromHex('0xEFFEf039cDDbc7d218Ddda702206a1bDd3E655e7');

//   //ACTUAL DEPLOYER
//   final deployerAddress = EthPrivateKey.fromHex(
//       '0c098d1a7dcac1f0c1800eed5955efa3b3b343713608c5227b83b8551b6e597d');
//   final testAddress = EthPrivateKey.fromHex(
//     '65f09c28414604a2dc3c78df732db52d4a4fe96007e05db407a729963ab3eb9e',
//   );

//   // final owner = Owner(address: contractAddress, client: client);

//   // print(locator<ContractService>().collection.address);

// //
//   // print(await owner.getOwner());
//   // client.call(contract: contract, function: function, params: params)

//   // owner.ownerSetEvents();
//   // final c =
//   // DeployedContract(ContractAbi.fromJson(abi, 'Owner'), contractAddress);
//   // print(c.);

//   try {
//     // final c = await loadCollectionContract();

//     // final result = await client.call(
//     //   contract: c,
//     //   function: c.function(fgetCollectionOverview),
//     //   params: [],
//     // );

//     // print(result);

//     // print('ADDRESS ' + c.address.toString());

//     final d = await deployerAddress.extractAddress();

//     // final service = GraphqlService();

//     // final ipfs = IPFSService();

//     // await ipfs
//     // .getJson('bafkreigydklifqcmhdfbnuyaejcbjc46346wc7b6dqiz3a5d2n6dnbr2am');

//     // await ipfs
//     // .get('bafybeihxyzvryabv2uwvyfn6p4d6qrxegpgkszyynylmgmlnlfl4kkuugq');

//     // await ipfs.get('QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR');

//     // print(await owner.getOwner());
//     // http.post('https://ipfs.io/');
//     // final a = await http.get('https://ipfs.io/');
//     // utf8.encode('Hello World!');

//     // final web3 =
//     // client.call(contract: c, function: c.function('owner'), params: []);

//     // final e = await client.sendTransaction(
//     //   deployerAddress,
//     //   // Transaction.callContract(
//     //   //   contract: c,
//     //   //   function: c.function('changeOwner'),
//     //   //   parameters: [d],
//     //   // ),
//     //   chainId: null,
//     //   fetchChainIdFromNetworkId: true,
//     // );
//     // uint8

//     // final t = Transaction.callContract(
//     //   from: await testAddress.extractAddress(),
//     //   contract: c,
//     //   function: c.function('set'),
//     //   parameters: ['aadfadfafcsdfaafadfafafdafafaa', true],
//     // );

//     // final gasInfo = await GasPriceService(client, Client()).getGasInfo(t);
//     // print(gasInfo);
//     // final a = FunctionType();

//     // final a = await client.estimateGas(
//     //   sender: await testAddress.extractAddress(),
//     //   to: t.to,
//     //   // data: Uint8List.fromList([d].cast<int>()),
//     //   data: t.data,

//     //   // data: t.data,
//     //   // t.data,
//     // );
//     // print(a);
//     // print(
//     //   await client.estimateGas(
//     //     sender: await deployerAddress.extractAddress(),
//     //     to: contractAddress,
//     //     // data: Uint8List(1),
//     //     // data:
//     //     // amountOfGas: BigInt.from(10),
//     //   ),
//     // );
//     // client.e
//     // final a = await owner.changeOwner(
//     //   // await deployerAddress.extractAddress(),
//     //   // credentials: testAddress,
//     //   await testAddress.extractAddress(),
//     //   credentials: deployerAddress,
//     //   // transaction: Transaction(
//     //   //   maxGas: 1000,
//     //   //   gasPrice: EtherAmount.inWei(BigInt.from(100)),
//     //   //   // :
//     //   // ),
//     // );

//     // client.get
//     // print(a);
//   } catch (e) {
//     debugPrint('Error: $e');
//   }
// }
