import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../models/item_pedido_request.dart';
import '../../models/produto.dart';
import '../../providers/cliente_provider.dart';
import '../../providers/pedido_provider.dart';
import '../../providers/produto_provider.dart';

class NovoPedidoScreen extends StatefulWidget {
  const NovoPedidoScreen({super.key});

  @override
  State<NovoPedidoScreen> createState() => _NovoPedidoScreenState();
}

class _NovoPedidoScreenState extends State<NovoPedidoScreen> {
  final _observacaoController = TextEditingController();
  final _motivoTrocaController = TextEditingController();

  Cliente? _clienteSelecionado;
  String _tipoPedido = 'NORMAL';
  final Map<int, int> _quantidades = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<ClienteProvider>().carregarClientes();
      await context.read<ProdutoProvider>().carregarProdutos();
    });
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    _motivoTrocaController.dispose();
    super.dispose();
  }

  void _alterarQuantidade(Produto produto, int quantidade) {
    setState(() {
      if (quantidade <= 0) {
        _quantidades.remove(produto.id);
      } else {
        _quantidades[produto.id] = quantidade;
      }
    });
  }

  double _calcularTotal(List<Produto> produtos) {
    double total = 0;

    for (final produto in produtos) {
      final quantidade = _quantidades[produto.id] ?? 0;
      total += produto.preco * quantidade;
    }

    return total;
  }

  Future<void> _enviarPedido(List<Produto> produtos) async {
    if (_clienteSelecionado == null) {
      _mostrarMensagem('Selecione um cliente.');
      return;
    }

    final itens = _quantidades.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => ItemPedidoRequest(
        produtoId: entry.key,
        quantidade: entry.value,
        desconto: 0,
      ),
    )
        .toList();

    if (itens.isEmpty) {
      _mostrarMensagem('Adicione pelo menos um produto.');
      return;
    }

    if (_tipoPedido == 'TROCA' && _motivoTrocaController.text.trim().isEmpty) {
      _mostrarMensagem('Informe o motivo da troca.');
      return;
    }

    final pedidoProvider = context.read<PedidoProvider>();

    final sucesso = await pedidoProvider.criarPedido(
      clienteId: _clienteSelecionado!.id,
      tipo: _tipoPedido,
      observacao: _observacaoController.text.trim().isEmpty
          ? null
          : _observacaoController.text.trim(),
      motivoTroca: _tipoPedido == 'TROCA'
          ? _motivoTrocaController.text.trim()
          : null,
      itens: itens,
    );

    if (!mounted) return;

    if (sucesso) {
      _mostrarMensagem('Pedido criado com sucesso.');
      Navigator.of(context).pop();
    } else {
      _mostrarMensagem(pedidoProvider.errorMessage ?? 'Erro ao criar pedido.');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = context.watch<ClienteProvider>();
    final produtoProvider = context.watch<ProdutoProvider>();
    final pedidoProvider = context.watch<PedidoProvider>();

    final carregandoDados =
        clienteProvider.isLoading || produtoProvider.isLoading;

    final produtos = produtoProvider.produtos;
    final total = _calcularTotal(produtos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo pedido'),
      ),
      body: carregandoDados
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<Cliente>(
              value: _clienteSelecionado,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
              items: clienteProvider.clientes.map((cliente) {
                return DropdownMenuItem(
                  value: cliente,
                  child: Text(cliente.nome),
                );
              }).toList(),
              onChanged: (cliente) {
                setState(() {
                  _clienteSelecionado = cliente;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipoPedido,
              decoration: const InputDecoration(
                labelText: 'Tipo do pedido',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'NORMAL',
                  child: Text('Pedido normal'),
                ),
                DropdownMenuItem(
                  value: 'TROCA',
                  child: Text('Pedido de troca'),
                ),
              ],
              onChanged: (tipo) {
                if (tipo == null) return;

                setState(() {
                  _tipoPedido = tipo;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            if (_tipoPedido == 'TROCA') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _motivoTrocaController,
                decoration: const InputDecoration(
                  labelText: 'Motivo da troca',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Produtos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...produtos.map((produto) {
              final quantidade = _quantidades[produto.id] ?? 0;

              return Card(
                child: ListTile(
                  title: Text(produto.nome),
                  subtitle: Text(
                    '${produto.codigo} • R\$ ${produto.preco.toStringAsFixed(2)}',
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: quantidade <= 0
                              ? null
                              : () => _alterarQuantidade(
                            produto,
                            quantidade - 1,
                          ),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$quantidade'),
                        IconButton(
                          onPressed: () => _alterarQuantidade(
                            produto,
                            quantidade + 1,
                          ),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: pedidoProvider.isLoading
                    ? null
                    : () => _enviarPedido(produtos),
                child: pedidoProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Enviar pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}