import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pedido.dart';
import '../../providers/pedido_provider.dart';
import 'detalhe_pedido_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  static const _opcaoTodos = 'TODOS';
  static const _statusOptions = [
    _opcaoTodos,
    'PENDENTE',
    'ENVIADO',
    'CANCELADO',
  ];
  static const _tipoOptions = [_opcaoTodos, 'NORMAL', 'TROCA'];

  String _statusSelecionado = _opcaoTodos;
  String _tipoSelecionado = _opcaoTodos;

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

  void _abrirDetalhePedido(Pedido pedido) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetalhePedidoScreen(pedidoId: pedido.id),
      ),
    );
  }

  bool _pedidoPassaNosFiltros(Pedido pedido) {
    final statusOk =
        _statusSelecionado == _opcaoTodos ||
        pedido.status.toUpperCase() == _statusSelecionado;
    final tipoOk =
        _tipoSelecionado == _opcaoTodos ||
        pedido.tipo.toUpperCase() == _tipoSelecionado;

    return statusOk && tipoOk;
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = context.watch<PedidoProvider>();
    final pedidosFiltrados = pedidoProvider.pedidos
        .where(_pedidoPassaNosFiltros)
        .toList();

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
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _statusSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: _statusOptions.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (status) {
                          if (status == null) return;

                          setState(() {
                            _statusSelecionado = status;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _tipoSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(),
                        ),
                        items: _tipoOptions.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                        onChanged: (tipo) {
                          if (tipo == null) return;

                          setState(() {
                            _tipoSelecionado = tipo;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (pedidosFiltrados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: Text('Nenhum pedido encontrado.')),
                  )
                else
                  ...pedidosFiltrados.map((pedido) {
                    return _PedidoCard(
                      pedido: pedido,
                      dataFormatada: _formatarData(pedido.dataCriacao),
                      valorFormatado: _formatarValor(pedido.valorTotal),
                      onTap: () => _abrirDetalhePedido(pedido),
                    );
                  }),
              ],
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
  final VoidCallback onTap;

  const _PedidoCard({
    required this.pedido,
    required this.dataFormatada,
    required this.valorFormatado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
}
