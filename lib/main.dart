import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/size_config.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizeConfiguration(
      designSize: const Size(375, 812),
      builder: (_) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.light(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
