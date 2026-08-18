import 'package:flutter/material.dart';

import '../models/cliente.dart';
import '../models/cliente_request.dart';
import '../services/cliente_service.dart';

class ClienteProvider extends ChangeNotifier {
  final ClienteService _clienteService;

  ClienteProvider({required ClienteService clienteService})
      : _clienteService = clienteService;

  bool _isLoading = false;
  String? _errorMessage;
  List<Cliente> _clientes = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Cliente> get clientes => _clientes;

  Future<bool> cadastrarCliente({
    required String razaoSocial,
    required String nomeFantasia,
    required String cnpj,
    String? inscricaoEstadual,
    String? nomeComprador,
    required String telefone,
    String? email,
    String? rua,
    String? bairro,
    required String cidade,
    required String estado,
    String? cep,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cliente = ClienteRequest(
        // Campos antigos para compatibilidade
        nome: nomeFantasia,
        cidade: cidade,
        telefone: telefone,
        email: email,
        documento: cnpj,

        // Campos novos
        razaoSocial: razaoSocial,
        nomeFantasia: nomeFantasia,
        cnpj: cnpj,
        inscricaoEstadual: inscricaoEstadual,
        nomeComprador: nomeComprador,
        rua: rua,
        bairro: bairro,
        estado: estado,
        cep: cep,
      );

      await _clienteService.cadastrarCliente(cliente);
      return true;
    } catch (error) {
      debugPrint('Erro ao cadastrar cliente: $error');
      _errorMessage = 'Erro ao cadastrar cliente.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarClientes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clientes = await _clienteService.listarClientes();
    } catch (error) {
      _errorMessage = 'Erro ao carregar clientes.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}