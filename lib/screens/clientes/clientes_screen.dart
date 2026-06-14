import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cliente_provider.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ClienteProvider>().carregarClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = context.watch<ClienteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Builder(
        builder: (_) {
          if (clienteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (clienteProvider.errorMessage != null) {
            return Center(
              child: Text(clienteProvider.errorMessage!),
            );
          }

          if (clienteProvider.clientes.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente encontrado.'),
            );
          }

          return ListView.builder(
            itemCount: clienteProvider.clientes.length,
            itemBuilder: (context, index) {
              final cliente = clienteProvider.clientes[index];

              return ListTile(
                title: Text(cliente.nome),
                subtitle: Text(cliente.cidade),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          );
        },
      ),
    );
  }
}