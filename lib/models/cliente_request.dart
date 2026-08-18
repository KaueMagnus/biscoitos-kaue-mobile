class ClienteRequest {
  final String? nome;
  final String? cidade;
  final String? telefone;
  final String? email;
  final String? documento;

  final String? razaoSocial;
  final String? nomeFantasia;
  final String? cnpj;
  final String? inscricaoEstadual;
  final String? nomeComprador;
  final String? rua;
  final String? bairro;
  final String? estado;
  final String? cep;

  ClienteRequest({
    this.nome,
    this.cidade,
    this.telefone,
    this.email,
    this.documento,
    this.razaoSocial,
    this.nomeFantasia,
    this.cnpj,
    this.inscricaoEstadual,
    this.nomeComprador,
    this.rua,
    this.bairro,
    this.estado,
    this.cep,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cidade': cidade,
      'telefone': telefone,
      'email': email,
      'documento': documento,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'cnpj': cnpj,
      'inscricaoEstadual': inscricaoEstadual,
      'nomeComprador': nomeComprador,
      'rua': rua,
      'bairro': bairro,
      'estado': estado,
      'cep': cep,
    };
  }
}