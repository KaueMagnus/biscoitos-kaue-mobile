import 'item_pedido_request.dart';

class PedidoRequest {
  final int clienteId;
  final String tipo;
  final String? observacao;
  final String? motivoTroca;
  final List<ItemPedidoRequest> itens;

  PedidoRequest({
    required this.clienteId,
    required this.tipo,
    this.observacao,
    this.motivoTroca,
    required this.itens,
  });

  Map<String, dynamic> toJson() {
    return {
      'clienteId': clienteId,
      'tipo': tipo,
      'observacao': observacao,
      'motivoTroca': motivoTroca,
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }
}