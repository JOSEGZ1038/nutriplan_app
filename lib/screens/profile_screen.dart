import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_drawer.dart';

/// Pantalla de perfil con un formulario validado.
/// Es StatefulWidget porque guarda lo que el usuario va eligiendo (sexo, actividad).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Llave que identifica al Form; con ella llamamos a validate().
  final _formKey = GlobalKey<FormState>();

  // Controladores para leer el texto de cada campo.
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();

  // Valores elegidos en los desplegables (null = todavía no eligió).
  String? _sexo;
  String? _actividad;

  // Opciones del nivel de actividad: clave interna → texto que ve el usuario.
  static const Map<String, String> _nivelesActividad = {
    'sedentario': 'Sedentario (poco o nada de ejercicio)',
    'ligero': 'Ligero (1-3 días por semana)',
    'moderado': 'Moderado (3-5 días por semana)',
    'intenso': 'Intenso (6-7 días por semana)',
  };

  @override
  void dispose() {
    // Liberar los controladores al salir de la pantalla para no gastar memoria.
    _edadController.dispose();
    _pesoController.dispose();
    _estaturaController.dispose();
    super.dispose();
  }

  /// Validador reutilizable para los campos numéricos.
  /// Devuelve un texto de error, o null si el valor es válido.
  String? _validarNumero(String? valor, String campo, double min, double max) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa tu $campo';
    }
    // Acepta coma o punto como separador decimal (70,5 o 70.5).
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null) {
      return 'Escribe un número válido';
    }
    if (numero < min || numero > max) {
      return 'Debe estar entre ${min.toInt()} y ${max.toInt()}';
    }
    return null; // null significa "sin errores"
  }

  /// Se ejecuta al pulsar "Calcular".
  void _enviar() {
    // validate() ejecuta TODOS los validator del Form y muestra los errores.
    if (!_formKey.currentState!.validate()) {
      return; // hay errores: no seguimos
    }

    final edad = int.parse(_edadController.text);
    final peso = double.parse(_pesoController.text.replaceAll(',', '.'));
    final estatura = double.parse(
      _estaturaController.text.replaceAll(',', '.'),
    );

    // Por ahora solo mostramos los datos. En el paso 6 los enviaremos
    // a una pantalla de resultado con GoRouter.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Datos válidos: $edad años, $peso kg, $estatura cm, '
          '$_sexo, $_actividad',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      drawer: const AppDrawer(),
      // SingleChildScrollView permite hacer scroll cuando aparece el teclado.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person, size: 64, color: Colors.green),
              const SizedBox(height: 8),
              const Text(
                'Completa tus datos para calcular tu gasto energético',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ---- Edad ----
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  suffixText: 'años',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                // Solo deja escribir dígitos.
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // La app es solo para adultos: mínimo 18 años.
                validator: (v) => _validarNumero(v, 'edad', 18, 100),
              ),
              const SizedBox(height: 16),

              // ---- Peso ----
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(
                  labelText: 'Peso',
                  suffixText: 'kg',
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                validator: (v) => _validarNumero(v, 'peso', 30, 300),
              ),
              const SizedBox(height: 16),

              // ---- Estatura ----
              TextFormField(
                controller: _estaturaController,
                decoration: const InputDecoration(
                  labelText: 'Estatura',
                  suffixText: 'cm',
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                validator: (v) => _validarNumero(v, 'estatura', 120, 230),
              ),
              const SizedBox(height: 16),

              // ---- Sexo (necesario para la fórmula de Mifflin-St Jeor) ----
              DropdownButtonFormField<String>(
                initialValue: _sexo,
                decoration: const InputDecoration(
                  labelText: 'Sexo (para el cálculo)',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'masculino',
                    child: Text('Masculino'),
                  ),
                  DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
                ],
                onChanged: (v) => setState(() => _sexo = v),
                validator: (v) => v == null ? 'Selecciona una opción' : null,
              ),
              const SizedBox(height: 16),

              // ---- Nivel de actividad ----
              DropdownButtonFormField<String>(
                initialValue: _actividad,
                isExpanded: true, // evita que el texto largo se desborde
                decoration: const InputDecoration(
                  labelText: 'Nivel de actividad',
                  prefixIcon: Icon(Icons.directions_run),
                  border: OutlineInputBorder(),
                ),
                // Convierte el Map en la lista de opciones del desplegable.
                items: _nivelesActividad.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _actividad = v),
                validator: (v) => v == null ? 'Selecciona una opción' : null,
              ),
              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _enviar,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
