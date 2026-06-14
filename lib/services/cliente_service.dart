import 'package:dio/dio.dart';

import '../models/cliente.dart';

class ClienteService {
  final Dio _dio;

  ClienteService(this._dio);

  Future<List<Cliente>> listarClientes() async {
    final response = await _dio.get('/clientes');

    final data = response.data as List;

    return data
        .map((clienteJson) => Cliente.fromJson(clienteJson))
        .toList();
  }
}