import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/size_config.dart';
import 'locator.dart';
import 'locator.dart' as di;
import 'provider/app_provider.dart';
import 'provider/collection_provider.dart';
import 'provider/creator_provider.dart';
import 'provider/wallet_provider.dart';
import 'screens/splash_screen/splash_screen.dart';

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
      ],
      child: SizeConfiguration(
        designSize: const Size(375, 812),
        builder: (_) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.light(),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
