import 'package:dio/dio.dart';

import '../models/auth_response.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'senha': senha,
      },
    );

    return AuthResponse.fromJson(response.data);
  }
}