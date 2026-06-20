class Pedido {
  final int id;
  final String clienteNome;
  final String tipo;
  final String status;
  final double valorTotal;
  final DateTime? dataCriacao;
  final List<ItemPedidoResponse> itens;

  Pedido({
    required this.id,
    required this.clienteNome,
    required this.tipo,
    required this.status,
    required this.valorTotal,
    required this.dataCriacao,
    required this.itens,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    final itensJson = json['itens'] as List? ?? [];

    return Pedido(
      id: json['id'],
      clienteNome: _lerNomeCliente(json),
      tipo: json['tipo'] ?? '',
      status: json['status'] ?? '',
      valorTotal: (json['valorTotal'] as num?)?.toDouble() ?? 0,
      dataCriacao: DateTime.tryParse(json['dataCriacao'] ?? ''),
      itens: itensJson
          .map((itemJson) => ItemPedidoResponse.fromJson(itemJson))
          .toList(),
    );
  }

  static String _lerNomeCliente(Map<String, dynamic> json) {
    if (json['nomeCliente'] != null) {
      return json['nomeCliente'];
    }

    if (json['clienteNome'] != null) {
      return json['clienteNome'];
    }

    final cliente = json['cliente'];
    if (cliente is Map<String, dynamic> && cliente['nome'] != null) {
      return cliente['nome'];
    }

    return 'Cliente não informado';
  }
}

class ItemPedidoResponse {
  final int? id;
  final int? produtoId;
  final String produtoNome;
  final int quantidade;
  final double precoUnitario;
  final double desconto;
  final double subtotal;

  ItemPedidoResponse({
    this.id,
    this.produtoId,
    required this.produtoNome,
    required this.quantidade,
    required this.precoUnitario,
    required this.desconto,
    required this.subtotal,
  });

  factory ItemPedidoResponse.fromJson(Map<String, dynamic> json) {
    return ItemPedidoResponse(
      id: json['id'],
      produtoId: json['produtoId'],
      produtoNome: _lerNomeProduto(json),
      quantidade: json['quantidade'] ?? 0,
      precoUnitario: (json['precoUnitario'] as num?)?.toDouble() ?? 0,
      desconto: (json['desconto'] as num?)?.toDouble() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
    );
  }

  static String _lerNomeProduto(Map<String, dynamic> json) {
    if (json['produtoNome'] != null) {
      return json['produtoNome'];
    }

    final produto = json['produto'];
    if (produto is Map<String, dynamic> && produto['nome'] != null) {
      return produto['nome'];
    }

    return 'Produto não informado';
  }
}
