class ClienteRequest {
  final String nome;
  final String cidade;
  final String? telefone;
  final String? email;
  final String? documento;

  ClienteRequest({
    required this.nome,
    required this.cidade,
    this.telefone,
    this.email,
    this.documento,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cidade': cidade,
      'telefone': telefone,
      'email': email,
      'documento': documento,
    };
  }
}
