import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

/// Pantalla del menú semanal.
/// Más adelante mostrará los 7 días con desayuno, almuerzo y cena.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú semanal')),
      drawer: const AppDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text('Aquí irá el menú de 7 días'),
          ],
        ),
      ),
    );
  }
}
