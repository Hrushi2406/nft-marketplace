import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

import 'config/config.dart';
import 'core/services/contract_service.dart';
import 'core/services/graphql_service.dart';
import 'core/services/wallet_service.dart';
import 'provider/app_provider.dart';
import 'provider/wallet_provider.dart';

final locator = GetIt.instance;

Future<void> init() async {
  //PROVIDER
  locator.registerLazySingleton(
      () => AppProvider(locator(), locator(), locator()));
  locator.registerLazySingleton(() => WalletProvider(locator(), locator()));

  //SERVICES
  locator.registerSingleton<ContractService>(ContractService());
  locator.registerLazySingleton(() => WalletService(locator()));
  locator.registerLazySingleton(() => GraphqlService());

  //CONFIG
  locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton(() => Web3Client(rpcURL, locator()));

  //PLUGINS
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(() => _prefs);
}
