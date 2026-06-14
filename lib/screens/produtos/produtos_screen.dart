import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/produto_provider.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProdutoProvider>().carregarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final produtoProvider = context.watch<ProdutoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: Builder(
        builder: (_) {
          if (produtoProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (produtoProvider.errorMessage != null) {
            return Center(
              child: Text(produtoProvider.errorMessage!),
            );
          }

          if (produtoProvider.produtos.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado.'),
            );
          }

          return ListView.builder(
            itemCount: produtoProvider.produtos.length,
            itemBuilder: (context, index) {
              final produto = produtoProvider.produtos[index];

              return ListTile(
                title: Text(produto.nome),
                subtitle: Text(produto.codigo),
                trailing: Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}