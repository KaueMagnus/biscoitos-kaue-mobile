class Cliente {
  final int id;
  final String nome;
  final String cidade;
  final String? telefone;
  final String? email;
  final String? documento;
  final bool ativo;

  Cliente({
    required this.id,
    required this.nome,
    required this.cidade,
    this.telefone,
    this.email,
    this.documento,
    required this.ativo,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      cidade: json['cidade'],
      telefone: json['telefone'],
      email: json['email'],
      documento: json['documento'],
      ativo: json['ativo'],
    );
  }
}