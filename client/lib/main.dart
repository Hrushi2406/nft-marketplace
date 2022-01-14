import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/size_config.dart';
import 'locator.dart';
import 'locator.dart' as di;
import 'provider/app_provider.dart';
import 'provider/collection_provider.dart';
import 'provider/creator_provider.dart';
import 'provider/fav_provider.dart';
import 'provider/nft_provider.dart';
import 'provider/search_provider.dart';
import 'provider/user_provider.dart';
import 'provider/wallet_provider.dart';
import 'screens/create_collection_screen/create_collection_screen.dart';
import 'screens/create_nft_screen/create_nft_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'screens/tabs_screen/tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => locator<AppProvider>()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => locator<WalletProvider>()),
        ChangeNotifierProvider(create: (_) => locator<CreatorProvider>()),
        ChangeNotifierProvider(create: (_) => locator<CollectionProvider>()),
        ChangeNotifierProvider(create: (_) => locator<NFTProvider>()),
        ChangeNotifierProvider(create: (_) => locator<FavProvider>()),
        ChangeNotifierProvider(create: (_) => locator<SearchProvider>()),
        ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
      ],
      child: SizeConfiguration(
        designSize: const Size(375, 812),
        builder: (_) {
          return MaterialApp(
            title: 'Mintit',
            theme: AppTheme.light(),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            home: const SplashScreen(),
            // home: TestMaticScreen(),
            routes: {
              'create_collection': (_) => const CreateCollectionScreen(),
              'create_nft': (_) => const CreateNFTScreen(),
              'tabs_screen': (_) => const TabsScreen(),
            },
            // home: const CreateCollectionScreen(),
            // home: const NetworkConfirmationScreen(),
          );
        },
      ),
    );
  }
}
