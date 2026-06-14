import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService _produtoService;

  ProdutoProvider({
    required ProdutoService produtoService,
  }) : _produtoService = produtoService;

  bool _isLoading = false;
  String? _errorMessage;
  List<Produto> _produtos = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Produto> get produtos => _produtos;

  Future<void> carregarProdutos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _produtos = await _produtoService.listarProdutos();
    } catch (error) {
      _errorMessage = 'Erro ao carregar produtos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}