import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menú lateral reutilizable: se coloca en el Scaffold de cada pantalla.
/// Navega con GoRouter usando context.go (reemplaza la ruta actual).
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Ruta en la que estamos ahora, para resaltar la opción activa.
    final String rutaActual = GoRouterState.of(context).uri.path;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.eco, size: 48, color: Colors.green),
                SizedBox(height: 8),
                Text('NutriPlan', style: TextStyle(fontSize: 24)),
                Text('Tu menú semanal personalizado'),
              ],
            ),
          ),
          _opcion(context, rutaActual, Icons.home, 'Inicio', '/'),
          _opcion(context, rutaActual, Icons.person, 'Mi perfil', '/perfil'),
          _opcion(
            context,
            rutaActual,
            Icons.restaurant_menu,
            'Menú semanal',
            '/menu',
          ),
          _opcion(
            context,
            rutaActual,
            Icons.shopping_cart,
            'Lista de mercado',
            '/mercado',
          ),
        ],
      ),
    );
  }

  /// Construye una opción del menú. Así no repetimos el mismo ListTile 4 veces.
  Widget _opcion(
    BuildContext context,
    String rutaActual,
    IconData icono,
    String titulo,
    String ruta,
  ) {
    return ListTile(
      leading: Icon(icono),
      title: Text(titulo),
      selected: rutaActual == ruta, // resalta la pantalla en la que estamos
      onTap: () {
        // Guardamos el router ANTES de cerrar el Drawer,
        // porque al cerrarlo este context deja de ser válido.
        final router = GoRouter.of(context);
        Navigator.of(context).pop(); // 1. cierra el Drawer
        router.go(ruta); // 2. navega a la pantalla elegida
      },
    );
  }
}
