import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/sdui/sdui_bootstrap.dart';
import 'core/sdui/sdui_screen_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerSDUIWidgets();
  runApp(const B2BMarketplaceApp());
}

class B2BMarketplaceApp extends StatelessWidget {
  const B2BMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B2B Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => SDUIScreenLoader(assetPath: 'assets/sdui/home_screen.json'),
        '/sign-in': (context) => SDUIScreenLoader(assetPath: 'assets/sdui/sign_in_screen.json'),
        '/login': (context) => SDUIScreenLoader(assetPath: 'assets/sdui/login_screen.json'),
      },
    );
  }
}
