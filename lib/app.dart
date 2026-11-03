import 'package:flutter/material.dart';

import 'router/app_router.dart';

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
