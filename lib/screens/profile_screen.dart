import 'package:flutter/material.dart';

/// Pantalla de perfil del usuario.
/// Por ahora solo muestra un texto; en el paso 5 aquí irá el formulario
/// (edad, peso, estatura, sexo y nivel de actividad).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold da la estructura básica de una pantalla: AppBar arriba y body.
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: const Center(
        // Column apila el ícono y el texto uno debajo del otro.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.green),
            SizedBox(height: 16), // espacio entre el ícono y el texto
            Text('Aquí irá el formulario'),
          ],
        ),
      ),
    );
  }
}
