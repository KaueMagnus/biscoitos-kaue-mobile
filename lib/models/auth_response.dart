class AuthResponse {
  final String token;
  final String tipo;

  AuthResponse({
    required this.token,
    required this.tipo,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      tipo: json['tipo'],
    );
  }
}