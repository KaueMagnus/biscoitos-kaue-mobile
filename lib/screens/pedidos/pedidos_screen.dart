import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pedido.dart';
import '../../providers/pedido_provider.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  @override
  void initState() {
    super.initState();

    final pedidoProvider = context.read<PedidoProvider>();
    Future.microtask(() {
      pedidoProvider.carregarPedidos();
    });
  }

  String _formatarData(DateTime? data) {
    if (data == null) {
      return 'Data não informada';
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();

    return '$dia/$mes/$ano';
  }

  String _formatarValor(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = context.watch<PedidoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: Builder(
        builder: (_) {
          if (pedidoProvider.isLoadingLista) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pedidoProvider.errorMessage != null) {
            return Center(child: Text(pedidoProvider.errorMessage!));
          }

          if (pedidoProvider.pedidos.isEmpty) {
            return const Center(child: Text('Nenhum pedido encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: pedidoProvider.carregarPedidos,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pedidoProvider.pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidoProvider.pedidos[index];

                return _PedidoCard(
                  pedido: pedido,
                  dataFormatada: _formatarData(pedido.dataCriacao),
                  valorFormatado: _formatarValor(pedido.valorTotal),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final String dataFormatada;
  final String valorFormatado;

  const _PedidoCard({
    required this.pedido,
    required this.dataFormatada,
    required this.valorFormatado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido #${pedido.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  valorFormatado,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(pedido.clienteNome),
            const SizedBox(height: 8),
            Text('Tipo: ${pedido.tipo}'),
            Text('Status: ${pedido.status}'),
            Text('Data: $dataFormatada'),
          ],
        ),
      ),
    );
  }
}
