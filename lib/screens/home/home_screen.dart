import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biscoitos Kauê'), centerTitle: true),
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
