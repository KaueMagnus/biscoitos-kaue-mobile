import 'package:dio/dio.dart';

import '../models/tabela_venda.dart';

class TabelaVendaService {
  final Dio _dio;

  TabelaVendaService(this._dio);

  Future<List<TabelaVenda>> listarTabelasVenda() async {
    final response = await _dio.get('/tabelas-venda');

    final data = response.data as List;

    return data.map((tabelaJson) => TabelaVenda.fromJson(tabelaJson)).toList();
  }
}
