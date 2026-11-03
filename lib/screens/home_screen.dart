import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Bienvenido a NutriPlan'),
            const SizedBox(height: 32),

            // push: APILA la pantalla encima de Inicio → aparece la flecha atrás.
            FilledButton.icon(
              onPressed: () => context.push('/perfil'),
              icon: const Icon(Icons.person),
              label: const Text('Mi perfil (push)'),
            ),
            const SizedBox(height: 12),

            // go: REEMPLAZA la ruta actual → no hay flecha atrás.
            FilledButton.icon(
              onPressed: () => context.go('/menu'),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Menú semanal (go)'),
            ),
            const SizedBox(height: 12),

            // pushNamed: igual que push, pero usando el NOMBRE de la ruta.
            FilledButton.icon(
              onPressed: () => context.pushNamed('mercado'),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Lista de mercado (pushNamed)'),
            ),
            const SizedBox(height: 12),

            // Prueba del errorBuilder con una ruta que no existe.
            OutlinedButton(
              onPressed: () => context.go('/no-existe'),
              child: const Text('Probar ruta inexistente'),
            ),
          ],
        ),
      ),
    );
  }
}
