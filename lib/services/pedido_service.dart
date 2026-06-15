import 'package:dio/dio.dart';

import '../models/pedido_request.dart';

class PedidoService {
  final Dio _dio;

  PedidoService(this._dio);

  Future<void> criarPedido(PedidoRequest pedido) async {
    await _dio.post(
      '/pedidos',
      data: pedido.toJson(),
    );
  }
}