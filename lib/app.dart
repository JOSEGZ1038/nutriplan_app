import 'package:flutter/material.dart';

import 'router/app_router.dart';

/// Widget raíz de la app.
/// Aplicado del video FLUTTER_03: se usa MaterialApp.router en lugar de
/// MaterialApp con "home", para que GoRouter (router/app_router.dart)
/// controle toda la navegación.
class NutriPlanApp extends StatelessWidget {
  const NutriPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router delega la navegación a GoRouter.
    return MaterialApp.router(
      title: 'NutriPlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
