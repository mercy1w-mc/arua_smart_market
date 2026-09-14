import 'package:flutter/material.dart';

import '../features/auth/presentation/sign_in_page.dart';
import '../features/customer/presentation/customer_shell.dart';
import '../features/farmer/presentation/farmer_shell.dart';
import '../shared/models/app_user.dart';

abstract final class AppRoutes {
  static const signIn = '/';
  static const customer = '/customer';
  static const farmer = '/farmer';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.customer:
      return MaterialPageRoute<void>(
        builder: (_) => const CustomerShell(),
        settings: settings,
      );
    case AppRoutes.farmer:
      return MaterialPageRoute<void>(
        builder: (_) => const FarmerShell(),
        settings: settings,
      );
    case AppRoutes.signIn:
    default:
      return MaterialPageRoute<void>(
        builder: (_) => const SignInPage(),
        settings: settings,
      );
  }
}

String routeForRole(UserRole role) {
  return role == UserRole.farmer ? AppRoutes.farmer : AppRoutes.customer;
}
