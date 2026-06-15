import 'package:flutter/material.dart';

import '../models/item_pedido_request.dart';
import '../models/pedido_request.dart';
import '../services/pedido_service.dart';

class PedidoProvider extends ChangeNotifier {
  final PedidoService _pedidoService;

  PedidoProvider({
    required PedidoService pedidoService,
  }) : _pedidoService = pedidoService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> criarPedido({
    required int clienteId,
    required String tipo,
    required List<ItemPedidoRequest> itens,
    String? observacao,
    String? motivoTroca,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pedido = PedidoRequest(
        clienteId: clienteId,
        tipo: tipo,
        observacao: observacao,
        motivoTroca: motivoTroca,
        itens: itens,
      );

      await _pedidoService.criarPedido(pedido);
      return true;
    } catch (error) {
      debugPrint('Erro ao criar pedido: $error');
      _errorMessage = 'Erro ao criar pedido.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}