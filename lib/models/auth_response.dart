class AuthResponse {
  final String token;
  final String tipo;

  AuthResponse({
    required this.token,
    required this.tipo,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final token = json['token'];

    if (token == null) {
      throw Exception('Token não encontrado na resposta do login.');
    }

    return AuthResponse(
      token: token.toString(),
      tipo: (json['tipo'] ?? json['perfil'] ?? '').toString(),
    );
  }
}