import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pedido.dart';
import '../../providers/pedido_provider.dart';

class DetalhePedidoScreen extends StatefulWidget {
  final int pedidoId;

  const DetalhePedidoScreen({super.key, required this.pedidoId});

  @override
  State<DetalhePedidoScreen> createState() => _DetalhePedidoScreenState();
}

class _DetalhePedidoScreenState extends State<DetalhePedidoScreen> {
  @override
  void initState() {
    super.initState();

    final pedidoProvider = context.read<PedidoProvider>();
    Future.microtask(() {
      pedidoProvider.carregarPedidoPorId(widget.pedidoId);
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

  bool _temTexto(String? texto) {
    return texto != null && texto.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = context.watch<PedidoProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Pedido #${widget.pedidoId}')),
      body: Builder(
        builder: (_) {
          if (pedidoProvider.isLoadingDetalhe) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pedidoProvider.errorMessageDetalhe != null) {
            return Center(child: Text(pedidoProvider.errorMessageDetalhe!));
          }

          final pedido = pedidoProvider.pedidoDetalhe;
          if (pedido == null) {
            return const Center(child: Text('Pedido não encontrado.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ResumoPedidoCard(
                pedido: pedido,
                dataFormatada: _formatarData(pedido.dataCriacao),
                valorFormatado: _formatarValor(pedido.valorTotal),
              ),
              if (_temTexto(pedido.observacao)) ...[
                const SizedBox(height: 12),
                _TextoCard(titulo: 'Observação', texto: pedido.observacao!),
              ],
              if (_temTexto(pedido.motivoTroca)) ...[
                const SizedBox(height: 12),
                _TextoCard(
                  titulo: 'Motivo da troca',
                  texto: pedido.motivoTroca!,
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Produtos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (pedido.itens.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhum produto encontrado.'),
                  ),
                )
              else
                ...pedido.itens.map(
                  (item) => _ItemPedidoCard(
                    item: item,
                    precoFormatado: _formatarValor(item.precoUnitario),
                    descontoFormatado: _formatarValor(item.desconto),
                    subtotalFormatado: _formatarValor(item.subtotal),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Total: ${_formatarValor(pedido.valorTotal)}',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResumoPedidoCard extends StatelessWidget {
  final Pedido pedido;
  final String dataFormatada;
  final String valorFormatado;

  const _ResumoPedidoCard({
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
            Text(
              pedido.clienteNome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Tipo: ${pedido.tipo}'),
            Text('Status: ${pedido.status}'),
            Text('Data: $dataFormatada'),
            Text('Total: $valorFormatado'),
          ],
        ),
      ),
    );
  }
}

class _TextoCard extends StatelessWidget {
  final String titulo;
  final String texto;

  const _TextoCard({required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(texto),
          ],
        ),
      ),
    );
  }
}

class _ItemPedidoCard extends StatelessWidget {
  final ItemPedidoResponse item;
  final String precoFormatado;
  final String descontoFormatado;
  final String subtotalFormatado;

  const _ItemPedidoCard({
    required this.item,
    required this.precoFormatado,
    required this.descontoFormatado,
    required this.subtotalFormatado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.produtoNome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Quantidade: ${item.quantidade}'),
            Text('Preço unitário: $precoFormatado'),
            Text('Desconto: $descontoFormatado'),
            Text('Subtotal: $subtotalFormatado'),
          ],
        ),
      ),
    );
  }
}
