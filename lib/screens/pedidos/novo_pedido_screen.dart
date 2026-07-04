import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/formatters/currency_formatter.dart';
import '../../core/theme/app_theme.dart';
import '../../models/cliente.dart';
import '../../models/item_pedido_request.dart';
import '../../models/produto.dart';
import '../../providers/cliente_provider.dart';
import '../../providers/pedido_provider.dart';
import '../../providers/produto_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_title.dart';

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
  final Map<int, TextEditingController> _quantidadeControllers = {};

  @override
  void initState() {
    super.initState();

    final clienteProvider = context.read<ClienteProvider>();
    final produtoProvider = context.read<ProdutoProvider>();
    Future.microtask(() async {
      await clienteProvider.carregarClientes();
      await produtoProvider.carregarProdutos();
    });
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    _motivoTrocaController.dispose();
    for (final controller in _quantidadeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _alterarQuantidade(Produto produto, int quantidade) {
    setState(() {
      if (quantidade <= 0) {
        _quantidades.remove(produto.id);
      } else {
        _quantidades[produto.id] = quantidade;
      }

      _atualizarTextoQuantidade(produto.id, quantidade);
    });
  }

  TextEditingController _controllerQuantidade(Produto produto) {
    return _quantidadeControllers.putIfAbsent(
      produto.id,
          () => TextEditingController(
        text: _quantidades[produto.id]?.toString() ?? '',
      ),
    );
  }

  void _atualizarTextoQuantidade(int produtoId, int quantidade) {
    final controller = _quantidadeControllers[produtoId];
    if (controller == null) return;

    final texto = quantidade <= 0 ? '' : quantidade.toString();
    controller.value = TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }

  void _digitarQuantidade(Produto produto, String valor) {
    final quantidade = int.tryParse(valor);

    setState(() {
      if (quantidade == null || quantidade <= 0) {
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
      AppSnackBar.showSuccess(context, 'Pedido enviado com sucesso!');
      Navigator.of(context).pop();
    } else {
      AppSnackBar.showError(
        context,
        pedidoProvider.errorMessage ?? 'Erro ao enviar pedido.',
      );
    }
  }

  void _mostrarMensagem(String mensagem) {
    AppSnackBar.showInfo(context, mensagem);
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
      appBar: AppBar(title: const Text('Novo pedido')),
      body: carregandoDados
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionTitle(
                  title: 'Dados do pedido',
                  subtitle: 'Selecione cliente, tipo e observações.',
                ),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    children: [
                      DropdownButtonFormField<Cliente>(
                        initialValue: _clienteSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Cliente',
                          prefixIcon: Icon(Icons.storefront_outlined),
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
                        initialValue: _tipoPedido,
                        decoration: const InputDecoration(
                          labelText: 'Tipo do pedido',
                          prefixIcon: Icon(Icons.receipt_long_outlined),
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
                          prefixIcon: Icon(Icons.notes_outlined),
                        ),
                        maxLines: 2,
                      ),
                      if (_tipoPedido == 'TROCA') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _motivoTrocaController,
                          decoration: const InputDecoration(
                            labelText: 'Motivo da troca',
                            prefixIcon: Icon(Icons.swap_horiz),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionTitle(
                  title: 'Produtos',
                  subtitle: 'Defina as quantidades para montar o pedido.',
                ),
                const SizedBox(height: 8),
                ...produtos.map((produto) {
                  final quantidade = _quantidades[produto.id] ?? 0;
                  final quantidadeController = _controllerQuantidade(produto);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  produto.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${produto.codigo} • ${formatarMoedaReal(produto.preco)}',
                                  style: const TextStyle(
                                    color: AppTheme.supportGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.creamCard,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: quantidade <= 0
                                      ? null
                                      : () => _alterarQuantidade(
                                          produto,
                                          quantidade - 1,
                                        ),
                                  icon: const Icon(Icons.remove),
                                  color: AppTheme.primaryRed,
                                ),
                                SizedBox(
                                  width: 54,
                                  child: TextField(
                                    controller: quantidadeController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: '0',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 10,
                                      ),
                                      border: InputBorder.none,
                                      filled: false,
                                    ),
                                    onChanged: (valor) =>
                                        _digitarQuantidade(produto, valor),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _alterarQuantidade(
                                    produto,
                                    quantidade + 1,
                                  ),
                                  icon: const Icon(Icons.add),
                                  color: AppTheme.primaryRed,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total do pedido',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatarMoedaReal(total),
                        style: const TextStyle(
                          color: AppTheme.primaryRed,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Enviar pedido',
                  icon: Icons.send_outlined,
                  isLoading: pedidoProvider.isLoading,
                  onPressed: () => _enviarPedido(produtos),
                ),
              ],
            ),
    );
  }
}
