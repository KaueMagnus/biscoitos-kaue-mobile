import 'item_pedido_request.dart';

class PedidoRequest {
  final int clienteId;
  final int? tabelaVendaId;
  final String tipo;
  final String formaPagamento;
  final String? observacao;
  final String? motivoTroca;
  final List<ItemPedidoRequest> itens;

  PedidoRequest({
    required this.clienteId,
    this.tabelaVendaId,
    required this.tipo,
    required this.formaPagamento,
    this.observacao,
    this.motivoTroca,
    required this.itens,
  });

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'tabelaVendaId': tabelaVendaId,
      'tipo': tipo,
      'formaPagamento': formaPagamento,
      'observacao': observacao,
      'motivoTroca': motivoTroca,
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }
}
