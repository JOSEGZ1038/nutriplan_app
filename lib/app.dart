import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class NutriPlanApp extends StatelessWidget {
  const NutriPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriPlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      // Temporal: en el paso 3 lo cambiaremos por MaterialApp.router con GoRouter.
      home: const HomeScreen(),
    );
  }
}
