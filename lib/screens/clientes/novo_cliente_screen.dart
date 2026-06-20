import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cliente_provider.dart';

class NovoClienteScreen extends StatefulWidget {
  const NovoClienteScreen({super.key});

  @override
  State<NovoClienteScreen> createState() => _NovoClienteScreenState();
}

class _NovoClienteScreenState extends State<NovoClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cidadeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  String? _validarObrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return '$campo é obrigatório.';
    }

    return null;
  }

  String? _textoOpcional(String texto) {
    final textoLimpo = texto.trim();

    if (textoLimpo.isEmpty) {
      return null;
    }

    return textoLimpo;
  }

  Future<void> _salvarCliente() async {
    final formValido = _formKey.currentState?.validate() ?? false;
    if (!formValido) {
      return;
    }

    final clienteProvider = context.read<ClienteProvider>();
    final sucesso = await clienteProvider.cadastrarCliente(
      nome: _nomeController.text.trim(),
      cidade: _cidadeController.text.trim(),
      telefone: _textoOpcional(_telefoneController.text),
      email: _textoOpcional(_emailController.text),
      documento: _textoOpcional(_documentoController.text),
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.of(context).pop(true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          clienteProvider.errorMessage ?? 'Não foi possível cadastrar cliente.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = context.watch<ClienteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => _validarObrigatorio(valor, 'Nome'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => _validarObrigatorio(valor, 'Cidade'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentoController,
                decoration: const InputDecoration(
                  labelText: 'Documento/CNPJ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: clienteProvider.isLoading ? null : _salvarCliente,
                  child: clienteProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Salvar cliente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
