import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  final tokenStorage = TokenStorage();
  final dio = ApiClient(tokenStorage).createDio();

  runApp(
    MultiProvider(
      providers: [
        Provider<TokenStorage>.value(value: tokenStorage),
        Provider<AuthService>(
          create: (_) => AuthService(dio),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authService: context.read<AuthService>(),
            tokenStorage: context.read<TokenStorage>(),
          ),
        ),
      ],
      child: const BiscoitosKaueApp(),
    ),
  );
}

class BiscoitosKaueApp extends StatelessWidget {
  const BiscoitosKaueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biscoitos Kauê',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}