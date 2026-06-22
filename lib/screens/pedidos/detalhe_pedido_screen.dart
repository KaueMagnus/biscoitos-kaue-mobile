import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/pedido.dart';
import '../../providers/pedido_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';
import '../../widgets/status_badge.dart';

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
              const SectionTitle(
                title: 'Produtos',
                subtitle: 'Itens incluídos neste pedido.',
              ),
              const SizedBox(height: 8),
              if (pedido.itens.isEmpty)
                const AppCard(child: Text('Nenhum produto encontrado.'))
              else
                ...pedido.itens.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ItemPedidoCard(
                      item: item,
                      precoFormatado: _formatarValor(item.precoUnitario),
                      descontoFormatado: _formatarValor(item.desconto),
                      subtotalFormatado: _formatarValor(item.subtotal),
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Valor total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatarValor(pedido.valorTotal),
                      style: const TextStyle(
                        color: AppTheme.primaryRed,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  pedido.clienteNome,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StatusBadge(status: pedido.status),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(label: 'Pedido #${pedido.id}'),
              _InfoPill(label: pedido.tipo),
              _InfoPill(label: dataFormatada),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Total: $valorFormatado',
            style: const TextStyle(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;

  const _InfoPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.creamCard,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.caramel,
          fontWeight: FontWeight.bold,
          fontSize: 12,
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(texto),
        ],
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.produtoNome,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text('Quantidade: ${item.quantidade}'),
          Text('Preço unitário: $precoFormatado'),
          Text('Desconto: $descontoFormatado'),
          const SizedBox(height: 6),
          Text(
            'Subtotal: $subtotalFormatado',
            style: const TextStyle(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
