import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

/// Pantalla de la lista de mercado.
/// Más adelante mostrará los ingredientes del menú agrupados y sumados.
class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de mercado')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text('Aquí irá la lista de compras'),
          ],
        ),
      ),
    );
  }
}
