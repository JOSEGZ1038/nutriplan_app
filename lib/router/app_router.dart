import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/shopping_list_screen.dart';

/// Configuración central de la navegación con GoRouter.
/// Cada GoRoute relaciona una ruta (path) con la pantalla que se muestra.
final GoRouter appRouter = GoRouter(
  initialLocation: '/', // ruta con la que arranca la app
  routes: [
    GoRoute(
      path: '/',
      name: 'inicio',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/perfil',
      name: 'perfil',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/menu',
      name: 'menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/mercado',
      name: 'mercado',
      builder: (context, state) => const ShoppingListScreen(),
    ),
  ],
  // Pantalla que se muestra si se navega a una ruta que no existe.
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: Center(child: Text('La ruta "${state.uri}" no existe')),
  ),
);
