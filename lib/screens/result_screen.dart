import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/perfil.dart';
import '../widgets/app_drawer.dart';

/// Muestra el resultado del cálculo.
/// Recibe el Perfil que le envió el formulario a través de GoRouter (extra).
class ResultScreen extends StatelessWidget {
  final Perfil? perfil;

  const ResultScreen({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    // El extra puede llegar vacío (por ejemplo, si alguien abre /resultado
    // directamente sin pasar por el formulario). En ese caso avisamos.
    if (perfil == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        drawer: const AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Primero completa tu perfil.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/perfil'),
                child: const Text('Ir a Mi perfil'),
              ),
            ],
          ),
        ),
      );
    }

    final p = perfil!;
    return Scaffold(
      appBar: AppBar(title: const Text('Tu resultado')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta con el gasto en reposo.
          _tarjeta(
            context,
            icono: Icons.bedtime,
            titulo: 'Gasto en reposo (GER)',
            valor: '${p.gastoReposo} kcal/día',
            detalle: 'Lo que tu cuerpo gasta sin hacer actividad.',
          ),
          const SizedBox(height: 12),
          // Tarjeta con el gasto total.
          _tarjeta(
            context,
            icono: Icons.local_fire_department,
            titulo: 'Gasto total (GET)',
            valor: '${p.gastoTotal} kcal/día',
            detalle: 'GER × factor de actividad (${p.factorActividad}).',
          ),
          const SizedBox(height: 24),

          // Resumen de los datos recibidos (demuestra que el extra llegó bien).
          Text('Datos usados', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Edad: ${p.edad} años'),
          Text('Peso: ${p.pesoKg} kg'),
          Text('Estatura: ${p.estaturaCm} cm'),
          Text('Sexo: ${p.sexo}'),
          Text('Actividad: ${p.actividad}'),
          const SizedBox(height: 16),

          const Text(
            'Fórmula de Mifflin-St Jeor. Es una estimación y no reemplaza '
            'la valoración de un profesional de la nutrición.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),

          // pop: vuelve al formulario, que conserva los datos escritos.
          OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.edit),
            label: const Text('Editar mis datos'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => context.go('/menu'),
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Ver mi menú semanal'),
          ),
        ],
      ),
    );
  }

  /// Tarjeta reutilizable para mostrar un valor destacado.
  Widget _tarjeta(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required String valor,
    required String detalle,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icono, size: 40, color: Colors.green),
        title: Text(titulo),
        subtitle: Text(detalle),
        trailing: Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
