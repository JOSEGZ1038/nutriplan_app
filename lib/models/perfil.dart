/// Modelo con los datos del usuario y los cálculos de gasto energético.
/// Está separado de las pantallas para poder probarlo con pruebas unitarias.
class Perfil {
  final int edad;
  final double pesoKg;
  final double estaturaCm;
  final String sexo; // 'masculino' o 'femenino'
  final String actividad; // 'sedentario', 'ligero', 'moderado' o 'intenso'

  const Perfil({
    required this.edad,
    required this.pesoKg,
    required this.estaturaCm,
    required this.sexo,
    required this.actividad,
  });

  /// Factores de actividad física de uso común.
  /// Son configurables: en el producto real los debe validar una nutricionista.
  static const Map<String, double> factoresActividad = {
    'sedentario': 1.2,
    'ligero': 1.375,
    'moderado': 1.55,
    'intenso': 1.725,
  };

  /// Gasto energético en reposo (GER) con la fórmula de Mifflin-St Jeor, sin redondear.
  ///   Hombres: 10 × peso + 6,25 × estatura − 5 × edad + 5
  ///   Mujeres: 10 × peso + 6,25 × estatura − 5 × edad − 161
  double get _gerExacto {
    final base = 10 * pesoKg + 6.25 * estaturaCm - 5 * edad;
    return sexo == 'masculino' ? base + 5 : base - 161;
  }

  /// GER redondeado a kcal/día.
  /// round() en Dart redondea .5 hacia arriba (1617,5 → 1618).
  int get gastoReposo => _gerExacto.round();

  /// Factor de la actividad elegida.
  double get factorActividad => factoresActividad[actividad]!;

  /// Gasto energético total (GET) = GER × factor de actividad.
  int get gastoTotal => (_gerExacto * factorActividad).round();

  /// Convierte el perfil a un Map con los nombres que espera la API (.NET).
  Map<String, dynamic> toJson() => {
    'edad': edad,
    'pesoKg': pesoKg,
    'estaturaCm': estaturaCm,
    'sexo': sexo,
    'actividad': actividad,
  };
}
