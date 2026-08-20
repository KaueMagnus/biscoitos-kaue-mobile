class TabelaVendaItem {
  final int produtoId;
  final double preco;

  TabelaVendaItem({required this.produtoId, required this.preco});

  factory TabelaVendaItem.fromJson(Map<String, dynamic> json) {
    return TabelaVendaItem(
      produtoId: (json['produtoId'] as num).toInt(),
      preco: (json['preco'] as num).toDouble(),
    );
  }
}

class TabelaVenda {
  final int id;
  final String nome;
  final List<TabelaVendaItem> itens;

  TabelaVenda({required this.id, required this.nome, required this.itens});

  factory TabelaVenda.fromJson(Map<String, dynamic> json) {
    final itensJson = json['itens'] as List? ?? [];

    return TabelaVenda(
      id: (json['id'] as num).toInt(),
      nome: json['nome'],
      itens: itensJson
          .map((itemJson) => TabelaVendaItem.fromJson(itemJson))
          .toList(),
    );
  }

  double? precoParaProduto(int produtoId) {
    for (final item in itens) {
      if (item.produtoId == produtoId) {
        return item.preco;
      }
    }

    return null;
  }
}
