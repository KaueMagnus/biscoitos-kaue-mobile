import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final _razaoSocialController = TextEditingController();
  final _nomeFantasiaController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _inscricaoEstadualController = TextEditingController();
  final _nomeCompradorController = TextEditingController();

  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();

  @override
  void dispose() {
    _razaoSocialController.dispose();
    _nomeFantasiaController.dispose();
    _cnpjController.dispose();
    _inscricaoEstadualController.dispose();
    _nomeCompradorController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  String? _validarObrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return '$campo é obrigatório.';
    }

    return null;
  }

  String? _validarCpfCnpj(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return 'CNPJ / CPF é obrigatório.';
    }

    final digitos = _somenteDigitos(texto);

    if (digitos.length != 11 && digitos.length != 14) {
      return 'Informe um CPF com 11 dígitos ou CNPJ com 14 dígitos.';
    }

    return null;
  }

  String? _validarTelefone(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return 'WhatsApp / Telefone é obrigatório.';
    }

    final digitos = _somenteDigitos(texto);

    if (digitos.length < 10 || digitos.length > 11) {
      return 'Informe um telefone com DDD.';
    }

    return null;
  }

  String? _validarEstado(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Estado é obrigatório.';
    }

    if (valor.trim().length != 2) {
      return 'Use a sigla do estado. Ex: SC';
    }

    return null;
  }

  String? _validarCepOpcional(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return null;
    }

    final digitos = _somenteDigitos(texto);

    if (digitos.length != 8) {
      return 'Informe um CEP com 8 dígitos.';
    }

    return null;
  }

  String? _validarEmailOpcional(String? valor) {
    final texto = valor?.trim() ?? '';

    if (texto.isEmpty) {
      return null;
    }

    if (!texto.contains('@') || !texto.contains('.')) {
      return 'Informe um e-mail válido.';
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

  String _somenteDigitos(String texto) {
    return texto.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> _salvarCliente() async {
    final formValido = _formKey.currentState?.validate() ?? false;

    if (!formValido) {
      return;
    }

    final clienteProvider = context.read<ClienteProvider>();

    final sucesso = await clienteProvider.cadastrarCliente(
      razaoSocial: _razaoSocialController.text.trim(),
      nomeFantasia: _nomeFantasiaController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      inscricaoEstadual: _textoOpcional(_inscricaoEstadualController.text),
      nomeComprador: _textoOpcional(_nomeCompradorController.text),
      telefone: _telefoneController.text.trim(),
      email: _textoOpcional(_emailController.text),
      rua: _textoOpcional(_ruaController.text),
      bairro: _textoOpcional(_bairroController.text),
      cidade: _cidadeController.text.trim(),
      estado: _estadoController.text.trim().toUpperCase(),
      cep: _textoOpcional(_cepController.text),
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
                      controller: _razaoSocialController,
                      decoration: const InputDecoration(
                        labelText: 'Razão Social',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (valor) =>
                          _validarObrigatorio(valor, 'Razão Social'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeFantasiaController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Fantasia',
                        prefixIcon: Icon(Icons.storefront_outlined),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (valor) =>
                          _validarObrigatorio(valor, 'Nome Fantasia'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cnpjController,
                      decoration: const InputDecoration(
                        labelText: 'CNPJ / CPF',
                        hintText: '00.000.000/0000-00',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfCnpjInputFormatter(),
                      ],
                      validator: _validarCpfCnpj,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _inscricaoEstadualController,
                      decoration: const InputDecoration(
                        labelText: 'IE / Isento',
                        hintText: 'Ex: ISENTO',
                        prefixIcon: Icon(Icons.confirmation_number_outlined),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(30),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeCompradorController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Comprador',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _telefoneController,
                      decoration: const InputDecoration(
                        labelText: 'WhatsApp / Telefone',
                        hintText: '(00) 00000-0000',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneInputFormatter(),
                      ],
                      validator: _validarTelefone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validarEmailOpcional,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _ruaController,
                      decoration: const InputDecoration(
                        labelText: 'Rua',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bairroController,
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (valor) =>
                          _validarObrigatorio(valor, 'Cidade'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _estadoController,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        hintText: 'SC',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: _validarEstado,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cepController,
                      decoration: const InputDecoration(
                        labelText: 'CEP',
                        hintText: '00000-000',
                        prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CepInputFormatter(),
                      ],
                      validator: _validarCepOpcional,
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

class CpfCnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 14) {
      digits = digits.substring(0, 14);
    }

    final formatted = digits.length <= 11
        ? _formatCpf(digits)
        : _formatCnpj(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatCpf(String digits) {
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('.');
      }

      if (i == 9) {
        buffer.write('-');
      }

      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  String _formatCnpj(String digits) {
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5) {
        buffer.write('.');
      }

      if (i == 8) {
        buffer.write('/');
      }

      if (i == 12) {
        buffer.write('-');
      }

      buffer.write(digits[i]);
    }

    return buffer.toString();
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    final formatted = _formatPhone(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatPhone(String digits) {
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i == 0) {
        buffer.write('(');
      }

      if (i == 2) {
        buffer.write(') ');
      }

      if (digits.length <= 10 && i == 6) {
        buffer.write('-');
      }

      if (digits.length == 11 && i == 7) {
        buffer.write('-');
      }

      buffer.write(digits[i]);
    }

    return buffer.toString();
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i == 5) {
        buffer.write('-');
      }

      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final upperText = newValue.text.toUpperCase();

    return TextEditingValue(
      text: upperText,
      selection: newValue.selection,
    );
  }
}