import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';
import '../auth/login_screen.dart';
import '../clientes/clientes_screen.dart';
import '../produtos/produtos_screen.dart';
import '../pedidos/novo_pedido_screen.dart';
import '../pedidos/pedidos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrirClientes(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ClientesScreen()));
  }

  void _abrirProdutos(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProdutosScreen()));
  }

  void _abrirNovoPedido(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NovoPedidoScreen()));
  }

  void _abrirPedidos(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PedidosScreen()));
  }

  Future<void> _sair(BuildContext context) async {
    final navigator = Navigator.of(context);
    final authProvider = context.read<AuthProvider>();

    await authProvider.logout();

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biscoitos Kauê'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _sair(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 58,
                  child: Image.asset(
                    'assets/images/logo_biscoitos_kaue.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu do representante',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Clientes, produtos e pedidos em um só lugar.',
                        style: TextStyle(color: AppTheme.gold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(
            title: 'Acessos rápidos',
            subtitle: 'Escolha uma operação para continuar.',
          ),
          const SizedBox(height: 12),
          _HomeActionCard(
            icon: Icons.people_alt_outlined,
            title: 'Clientes',
            subtitle: 'Consultar e cadastrar clientes',
            onTap: () => _abrirClientes(context),
          ),
          const SizedBox(height: 12),
          _HomeActionCard(
            icon: Icons.inventory_2_outlined,
            title: 'Produtos',
            subtitle: 'Ver catálogo e preços',
            onTap: () => _abrirProdutos(context),
          ),
          const SizedBox(height: 12),
          _HomeActionCard(
            icon: Icons.add_shopping_cart,
            title: 'Novo pedido',
            subtitle: 'Criar pedido normal ou troca',
            onTap: () => _abrirNovoPedido(context),
          ),
          const SizedBox(height: 12),
          _HomeActionCard(
            icon: Icons.receipt_long_outlined,
            title: 'Pedidos',
            subtitle: 'Acompanhar status e detalhes',
            onTap: () => _abrirPedidos(context),
          ),
          const SizedBox(height: 12),
          _HomeActionCard(
            icon: Icons.logout,
            title: 'Sair',
            subtitle: 'Encerrar sessão com segurança',
            isDestructive: true,
            onTap: () => _sair(context),
          ),
        ],
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.cancelRed : AppTheme.primaryRed;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.supportGray),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.supportGray),
        ],
      ),
    );
  }
}
