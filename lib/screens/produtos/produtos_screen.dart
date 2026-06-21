import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/produto.dart';
import '../../providers/produto_provider.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final produtoProvider = context.read<ProdutoProvider>();
    Future.microtask(() {
      produtoProvider.carregarProdutos();
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

  @override
  Widget build(BuildContext context) {
    final produtoProvider = context.watch<ProdutoProvider>();
    final produtosFiltrados = produtoProvider.produtos
        .where(_produtoContemBusca)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Builder(
        builder: (_) {
          if (produtoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (produtoProvider.errorMessage != null) {
            return Center(child: Text(produtoProvider.errorMessage!));
          }

          if (produtoProvider.produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _buscaController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar produto',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _atualizarBusca(),
                ),
              ),
              Expanded(
                child: produtosFiltrados.isEmpty
                    ? const Center(child: Text('Nenhum produto encontrado.'))
                    : ListView.builder(
                        itemCount: produtosFiltrados.length,
                        itemBuilder: (context, index) {
                          final produto = produtosFiltrados[index];

                          return ListTile(
                            title: Text(produto.nome),
                            subtitle: Text(produto.codigo),
                            trailing: Text(
                              'R\$ ${produto.preco.toStringAsFixed(2)}',
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
