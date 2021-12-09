import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:nfts/core/services/gasprice_service.dart';
import 'package:nfts/core/services/image_picker_service.dart';
import 'package:nfts/provider/nft_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

import 'config/config.dart';
import 'core/services/contract_service.dart';
import 'core/services/graphql_service.dart';
import 'core/services/ipfs_service.dart';
import 'core/services/wallet_service.dart';
import 'provider/app_provider.dart';
import 'provider/collection_provider.dart';
import 'provider/creator_provider.dart';
import 'provider/wallet_provider.dart';

final locator = GetIt.instance;

Future<void> init() async {
  //PROVIDER
  locator.registerLazySingleton(
      () => AppProvider(locator(), locator(), locator(), locator()));
  locator.registerLazySingleton(
      () => WalletProvider(locator(), locator(), locator()));
  locator.registerLazySingleton(() => CreatorProvider(locator(), locator()));
  locator.registerLazySingleton(() => NFTProvider(locator(), locator()));
  locator.registerLazySingleton(() => CollectionProvider(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  //SERVICES
  locator.registerSingleton<ContractService>(ContractService());
  locator.registerLazySingleton(() => WalletService(locator()));
  locator.registerLazySingleton(() => GraphqlService());
  locator.registerLazySingleton(() => IPFSService(locator()));
  locator.registerLazySingleton(() => GasPriceService(locator(), locator()));
  locator.registerLazySingleton(() => ImagePickerService());

  //CONFIG
  locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton(() => Web3Client(rpcURL, locator()));

  //PLUGINS
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(() => _prefs);
}
