import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class AruaSmartMarketApp extends StatelessWidget {
  const AruaSmartMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arua Smart Market',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.signIn,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
