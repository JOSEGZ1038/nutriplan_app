import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/shopping_list_screen.dart';
import '../models/perfil.dart';
import '../screens/result_screen.dart';

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
    GoRoute(
      path: '/resultado',
      name: 'resultado',
      // state.extra trae el objeto que envió el formulario.
      // "as Perfil?" lo convierte al tipo Perfil (o null si no llegó nada).
      builder: (context, state) => ResultScreen(perfil: state.extra as Perfil?),
    ),
  ],
  // Pantalla que se muestra si se navega a una ruta que no existe.
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: Center(child: Text('La ruta "${state.uri}" no existe')),
  ),
);
