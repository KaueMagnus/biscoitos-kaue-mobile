import 'package:dio/dio.dart';

import '../models/produto.dart';

class ProdutoService {
  final Dio _dio;

  ProdutoService(this._dio);

  Future<List<Produto>> listarProdutos() async {
    final response = await _dio.get('/produtos');

    final data = response.data as List;

    return data
        .map((produtoJson) => Produto.fromJson(produtoJson))
        .toList();
  }
}