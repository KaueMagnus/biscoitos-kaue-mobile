import 'package:dio/dio.dart';

import '../models/pedido.dart';
import '../models/pedido_request.dart';

class PedidoService {
  final Dio _dio;

  PedidoService(this._dio);

  Future<void> criarPedido(PedidoRequest pedido) async {
    await _dio.post('/pedidos', data: pedido.toJson());
  }

  Future<List<Pedido>> listarPedidos() async {
    final response = await _dio.get('/pedidos');

    final data = response.data as List;

    return data.map((pedidoJson) => Pedido.fromJson(pedidoJson)).toList();
  }

  Future<Pedido> buscarPedidoPorId(int id) async {
    final response = await _dio.get('/pedidos/$id');

    return Pedido.fromJson(response.data);
  }
}
