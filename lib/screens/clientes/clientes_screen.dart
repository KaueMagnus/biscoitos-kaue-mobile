import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../providers/cliente_provider.dart';
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _buscaController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar cliente',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _atualizarBusca(),
                ),
              ),
              Expanded(
                child: clientesFiltrados.isEmpty
                    ? const Center(child: Text('Nenhum cliente encontrado.'))
                    : ListView.builder(
                        itemCount: clientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final cliente = clientesFiltrados[index];

                          return ListTile(
                            title: Text(cliente.nome),
                            subtitle: Text(cliente.cidade),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
