class Produto {
  final int id;
  final String codigo;
  final String nome;
  final String? descricao;
  final double preco;
  final bool ativo;

  Produto({
    required this.id,
    required this.codigo,
    required this.nome,
    this.descricao,
    required this.preco,
    required this.ativo,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      codigo: json['codigo'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
      ativo: json['ativo'],
    );
  }
}