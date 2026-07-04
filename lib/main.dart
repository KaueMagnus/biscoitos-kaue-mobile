import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cliente_provider.dart';
import 'providers/produto_provider.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';
import 'services/cliente_service.dart';
import 'services/produto_service.dart';
import 'providers/pedido_provider.dart';
import 'services/pedido_service.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final dio = ApiClient(tokenStorage).createDio();

  runApp(
    MultiProvider(
      providers: [
        Provider<TokenStorage>.value(value: tokenStorage),
        Provider<AuthService>(create: (_) => AuthService(dio)),
        Provider<ClienteService>(create: (_) => ClienteService(dio)),
        Provider<ProdutoService>(create: (_) => ProdutoService(dio)),
        Provider<PedidoService>(create: (_) => PedidoService(dio)),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authService: context.read<AuthService>(),
            tokenStorage: context.read<TokenStorage>(),
          ),
        ),
        ChangeNotifierProvider<ClienteProvider>(
          create: (context) =>
              ClienteProvider(clienteService: context.read<ClienteService>()),
        ),
        ChangeNotifierProvider<ProdutoProvider>(
          create: (context) =>
              ProdutoProvider(produtoService: context.read<ProdutoService>()),
        ),
        ChangeNotifierProvider<PedidoProvider>(
          create: (context) =>
              PedidoProvider(pedidoService: context.read<PedidoService>()),
        ),
      ],
      child: BiscoitosKaueApp(tokenStorage: tokenStorage),
    ),
  );
}

class BiscoitosKaueApp extends StatelessWidget {
  final TokenStorage tokenStorage;

  const BiscoitosKaueApp({
    super.key,
    required this.tokenStorage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biscoitos Kauê',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: FutureBuilder<String?>(
        future: tokenStorage.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final token = snapshot.data;

          if (token != null && token.isNotEmpty) {
            return const HomeScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
