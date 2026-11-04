import 'package:flutter_test/flutter_test.dart';
import 'package:nutriplan_app/models/perfil.dart';

void main() {
  // Caso de referencia: adulto de 30 años, 70 kg, 170 cm.
  Perfil crear(String sexo, String actividad) => Perfil(
    edad: 30,
    pesoKg: 70,
    estaturaCm: 170,
    sexo: sexo,
    actividad: actividad,
  );

  group('Mifflin-St Jeor (GER)', () {
    test('hombre de referencia = 1618 kcal', () {
      // 10×70 + 6,25×170 − 5×30 + 5 = 1617,5 → 1618
      expect(crear('masculino', 'sedentario').gastoReposo, 1618);
    });

    test('mujer de referencia = 1452 kcal', () {
      // 10×70 + 6,25×170 − 5×30 − 161 = 1451,5 → 1452
      expect(crear('femenino', 'sedentario').gastoReposo, 1452);
    });
  });

  group('Gasto total (GET = GER × factor)', () {
    test('hombre sedentario: 1617,5 × 1,2 = 1941', () {
      expect(crear('masculino', 'sedentario').gastoTotal, 1941);
    });

    test('hombre moderado: 1617,5 × 1,55 = 2507', () {
      expect(crear('masculino', 'moderado').gastoTotal, 2507);
    });

    test('mujer ligera: 1451,5 × 1,375 = 1996', () {
      expect(crear('femenino', 'ligero').gastoTotal, 1996);
    });
  });
}
