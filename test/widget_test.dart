import 'package:flutter_test/flutter_test.dart';
import 'package:nutriplan_app/app.dart';

void main() {
  testWidgets('La app arranca en la pantalla de Inicio', (tester) async {
    await tester.pumpWidget(const NutriPlanApp());
    await tester.pumpAndSettle(); // espera a que GoRouter muestre la ruta '/'
    expect(find.text('Bienvenido a NutriPlan'), findsOneWidget);
  });
}
