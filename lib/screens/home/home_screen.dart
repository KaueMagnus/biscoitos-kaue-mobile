import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../clientes/clientes_screen.dart';
import '../produtos/produtos_screen.dart';
import '../pedidos/novo_pedido_screen.dart';
import '../pedidos/pedidos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrirClientes(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ClientesScreen()));
  }

  void _abrirProdutos(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProdutosScreen()));
  }

  void _abrirNovoPedido(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NovoPedidoScreen()));
  }

  void _abrirPedidos(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PedidosScreen()));
  }

  Future<void> _sair(BuildContext context) async {
    final navigator = Navigator.of(context);
    final authProvider = context.read<AuthProvider>();

    await authProvider.logout();

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biscoitos Kauê'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _sair(context),
            child: const Text('Sair'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Menu principal',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _abrirClientes(context),
              child: const Text('Clientes'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _abrirProdutos(context),
              child: const Text('Produtos'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _abrirNovoPedido(context),
              child: const Text('Novo pedido'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _abrirPedidos(context),
              child: const Text('Pedidos'),
            ),
          ],
        ),
      ),
    );
  }
}
