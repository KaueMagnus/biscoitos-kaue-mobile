import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/cliente.dart';
import '../../providers/cliente_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';
import 'novo_cliente_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final clienteProvider = context.read<ClienteProvider>();
    Future.microtask(() {
      clienteProvider.carregarClientes();
    });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _atualizarBusca() {
    setState(() {});
  }

  bool _clienteContemBusca(Cliente cliente) {
    final busca = _buscaController.text.trim().toLowerCase();

    if (busca.isEmpty) {
      return true;
    }

    final nome = cliente.nome.toLowerCase();
    final cidade = cliente.cidade.toLowerCase();
    final documento = cliente.documento?.toLowerCase() ?? '';

    return nome.contains(busca) ||
        cidade.contains(busca) ||
        documento.contains(busca);
  }

  Future<void> _abrirCadastroCliente() async {
    final clienteProvider = context.read<ClienteProvider>();
    final cadastrou = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const NovoClienteScreen()));

    if (!mounted) return;

    if (cadastrou == true) {
      await clienteProvider.carregarClientes();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente cadastrado com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = context.watch<ClienteProvider>();
    final clientesFiltrados = clienteProvider.clientes
        .where(_clienteContemBusca)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            onPressed: _abrirCadastroCliente,
            icon: const Icon(Icons.add),
            tooltip: 'Novo cliente',
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (clienteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (clienteProvider.errorMessage != null) {
            return Center(child: Text(clienteProvider.errorMessage!));
          }

          if (clienteProvider.clientes.isEmpty) {
            return const Center(child: Text('Nenhum cliente encontrado.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionTitle(
                title: 'Clientes',
                subtitle: 'Busque por nome, cidade ou documento.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _buscaController,
                decoration: const InputDecoration(
                  labelText: 'Buscar cliente',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => _atualizarBusca(),
              ),
              const SizedBox(height: 12),
              if (clientesFiltrados.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(child: Text('Nenhum cliente encontrado.')),
                )
              else
                ...clientesFiltrados.map((cliente) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.storefront_outlined,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cliente.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cliente.cidade,
                                  style: const TextStyle(
                                    color: AppTheme.supportGray,
                                  ),
                                ),
                                if (cliente.documento != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    cliente.documento!,
                                    style: const TextStyle(
                                      color: AppTheme.caramel,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
