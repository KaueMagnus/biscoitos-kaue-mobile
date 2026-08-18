class Cliente {
  final int id;
  final String nome;
  final String cidade;
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

  final bool ativo;

  Cliente({
    required this.id,
    required this.nome,
    required this.cidade,
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
    required this.ativo,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: (json['id'] as num).toInt(),
      nome:
      json['nome'] ??
          json['nomeFantasia'] ??
          json['razaoSocial'] ??
          'Cliente sem nome',
      cidade: json['cidade'] ?? '',
      telefone: json['telefone'],
      email: json['email'],
      documento: json['documento'],
      razaoSocial: json['razaoSocial'],
      nomeFantasia: json['nomeFantasia'],
      cnpj: json['cnpj'],
      inscricaoEstadual: json['inscricaoEstadual'],
      nomeComprador: json['nomeComprador'],
      rua: json['rua'],
      bairro: json['bairro'],
      estado: json['estado'],
      cep: json['cep'],
      ativo: json['ativo'] ?? true,
    );
  }
}