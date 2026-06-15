class ItemPedidoRequest {
  final int produtoId;
  final int quantidade;
  final double desconto;

  ItemPedidoRequest({
    required this.produtoId,
    required this.quantidade,
    this.desconto = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'quantidade': quantidade,
      'desconto': desconto,
    };
  }
}