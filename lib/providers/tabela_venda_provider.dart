import 'package:flutter/material.dart';

import '../models/tabela_venda.dart';
import '../services/tabela_venda_service.dart';

class TabelaVendaProvider extends ChangeNotifier {
  final TabelaVendaService _tabelaVendaService;

  TabelaVendaProvider({required TabelaVendaService tabelaVendaService})
    : _tabelaVendaService = tabelaVendaService;

  bool _isLoading = false;
  String? _errorMessage;
  List<TabelaVenda> _tabelasVenda = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<TabelaVenda> get tabelasVenda => _tabelasVenda;

  Future<void> carregarTabelasVenda() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tabelasVenda = await _tabelaVendaService.listarTabelasVenda();
    } catch (error) {
      _errorMessage = 'Erro ao carregar tabelas de venda.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
