import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/unidades_por_caixa.dart';
import '../../core/formatters/currency_formatter.dart';
import '../../core/theme/app_theme.dart';
import '../../models/produto.dart';
import '../../models/tabela_venda.dart';
import '../../providers/produto_provider.dart';
import '../../providers/tabela_venda_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final _buscaController = TextEditingController();
  TabelaVenda? _tabelaSelecionada;

  @override
  void initState() {
    super.initState();

    final produtoProvider = context.read<ProdutoProvider>();
    final tabelaVendaProvider = context.read<TabelaVendaProvider>();
    Future.microtask(() async {
      await produtoProvider.carregarProdutos();
      await tabelaVendaProvider.carregarTabelasVenda();

      if (!mounted) return;

      final tabelas = tabelaVendaProvider.tabelasVenda;
      if (tabelas.length == 1) {
        setState(() {
          _tabelaSelecionada = tabelas.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _atualizarBusca() {
    setState(() {});
  }

  bool _produtoContemBusca(Produto produto) {
    final busca = _buscaController.text.trim().toLowerCase();

    if (busca.isEmpty) {
      return true;
    }

    final nome = produto.nome.toLowerCase();
    final codigo = produto.codigo.toLowerCase();

    return nome.contains(busca) || codigo.contains(busca);
  }

  double _precoProduto(Produto produto, TabelaVenda? tabela) {
    return tabela?.precoParaProduto(produto.id) ?? produto.preco;
  }

  @override
  Widget build(BuildContext context) {
    final produtoProvider = context.watch<ProdutoProvider>();
    final tabelaVendaProvider = context.watch<TabelaVendaProvider>();
    final produtosFiltrados = produtoProvider.produtos
        .where(_produtoContemBusca)
        .toList();

    final tabelasVenda = tabelaVendaProvider.tabelasVenda;

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Builder(
        builder: (_) {
          if (produtoProvider.isLoading || tabelaVendaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (produtoProvider.errorMessage != null) {
            return Center(child: Text(produtoProvider.errorMessage!));
          }

          if (produtoProvider.produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionTitle(
                title: 'Produtos',
                subtitle: 'Busque por nome ou código.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _buscaController,
                decoration: const InputDecoration(
                  labelText: 'Buscar produto',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => _atualizarBusca(),
              ),
              if (tabelasVenda.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<TabelaVenda?>(
                  initialValue: _tabelaSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Tabela de preço',
                    prefixIcon: Icon(Icons.price_change_outlined),
                  ),
                  items: [
                    const DropdownMenuItem<TabelaVenda?>(
                      value: null,
                      child: Text('Preço padrão'),
                    ),
                    ...tabelasVenda.map((tabela) {
                      return DropdownMenuItem<TabelaVenda?>(
                        value: tabela,
                        child: Text(tabela.nome),
                      );
                    }),
                  ],
                  onChanged: (tabela) {
                    setState(() {
                      _tabelaSelecionada = tabela;
                    });
                  },
                ),
              ],
              const SizedBox(height: 12),
              if (produtosFiltrados.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(child: Text('Nenhum produto encontrado.')),
                )
              else
                ...produtosFiltrados.map((produto) {
                  final unidadesPorCaixa = unidadesPorCaixaPorCodigo(
                    produto.codigo,
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.cookie_outlined,
                              color: AppTheme.caramel,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  produto.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (unidadesPorCaixa != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'cx = ${unidadesPorCaixa}un',
                                    style: const TextStyle(
                                      color: AppTheme.supportGray,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Text(
                                  'Código ${produto.codigo}',
                                  style: const TextStyle(
                                    color: AppTheme.supportGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatarMoedaReal(
                              _precoProduto(produto, _tabelaSelecionada),
                            ),
                            style: const TextStyle(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
