import 'package:flutter/material.dart';

import '../models/item_pedido_request.dart';
import '../models/pedido.dart';
import '../models/pedido_request.dart';
import '../services/pedido_service.dart';

class PedidoProvider extends ChangeNotifier {
  final PedidoService _pedidoService;

  PedidoProvider({required PedidoService pedidoService})
    : _pedidoService = pedidoService;

  bool _isLoading = false;
  bool _isLoadingLista = false;
  String? _errorMessage;
  List<Pedido> _pedidos = [];

  bool get isLoading => _isLoading;
  bool get isLoadingLista => _isLoadingLista;
  String? get errorMessage => _errorMessage;
  List<Pedido> get pedidos => _pedidos;

  Future<void> carregarPedidos() async {
    _isLoadingLista = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pedidos = await _pedidoService.listarPedidos();
    } catch (error) {
      debugPrint('Erro ao carregar pedidos: $error');
      _errorMessage = 'Erro ao carregar pedidos.';
    } finally {
      _isLoadingLista = false;
      notifyListeners();
    }
  }

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
