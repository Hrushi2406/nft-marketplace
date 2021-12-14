import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

import 'config/config.dart';
import 'core/services/contract_service.dart';
import 'core/services/gasprice_service.dart';
import 'core/services/graphql_service.dart';
import 'core/services/image_picker_service.dart';
import 'core/services/ipfs_service.dart';
import 'core/services/nft_repo.dart';
import 'core/services/wallet_service.dart';
import 'provider/app_provider.dart';
import 'provider/collection_provider.dart';
import 'provider/creator_provider.dart';
import 'provider/fav_provider.dart';
import 'provider/nft_provider.dart';
import 'provider/search_provider.dart';
import 'provider/user_provider.dart';
import 'provider/wallet_provider.dart';

final locator = GetIt.instance;

Future<void> init() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  //PROVIDER
  locator.registerLazySingleton<AppProvider>(() => AppProvider(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerLazySingleton<FavProvider>(() => FavProvider(locator()));
  locator
      .registerLazySingleton<SearchProvider>(() => SearchProvider(locator()));
  locator.registerLazySingleton<UserProvider>(
      () => UserProvider(locator(), locator()));

  locator.registerLazySingleton<WalletProvider>(() => WalletProvider(
        locator(),
        locator(),
        locator(),
        locator(),
      ));
  locator.registerLazySingleton<CreatorProvider>(
      () => CreatorProvider(locator(), locator()));
  locator.registerLazySingleton<NFTProvider>(() => NFTProvider(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));
  locator.registerLazySingleton<CollectionProvider>(() => CollectionProvider(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  //SERVICES
  locator.registerSingleton<ContractService>(ContractService());
  locator.registerLazySingleton<WalletService>(() => WalletService(locator()));
  locator.registerLazySingleton<NFTRepo>(() => NFTRepo(locator(), locator()));
  locator
      .registerLazySingleton<GraphqlService>(() => GraphqlService(GraphQLClient(
            link: HttpLink(graphqlURL),
            cache: GraphQLCache(),
          )));
  locator.registerLazySingleton<IPFSService>(() => IPFSService(locator()));
  locator.registerLazySingleton<GasPriceService>(
      () => GasPriceService(locator(), locator()));
  locator.registerLazySingleton<ImagePickerService>(() => ImagePickerService());

  //CONFIG
  locator.registerLazySingleton<http.Client>(() => http.Client());

  locator
      .registerLazySingleton<Web3Client>(() => Web3Client(rpcURL, locator()));

  //PLUGINS

  locator.registerLazySingleton<SharedPreferences>(() => _prefs);
}
