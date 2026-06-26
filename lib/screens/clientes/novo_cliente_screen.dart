import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cliente_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_title.dart';

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

    AppSnackBar.showError(
      context,
      clienteProvider.errorMessage ?? 'Erro ao cadastrar cliente.',
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
              const SectionTitle(
                title: 'Cadastrar cliente',
                subtitle: 'O cliente será vinculado ao representante logado.',
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.storefront_outlined),
                      ),
                      validator: (valor) => _validarObrigatorio(valor, 'Nome'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (valor) =>
                          _validarObrigatorio(valor, 'Cidade'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _documentoController,
                      decoration: const InputDecoration(
                        labelText: 'Documento/CNPJ',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Salvar cliente',
                icon: Icons.save_outlined,
                isLoading: clienteProvider.isLoading,
                onPressed: _salvarCliente,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
