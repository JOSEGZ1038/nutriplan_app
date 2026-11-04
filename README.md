# NutriPlan — Práctica Flutter: GoRouter, pantallas y Docker

Aplicación móvil en Flutter que demuestra navegación con **GoRouter**, menú lateral
(**Drawer**), **formularios con validación**, paso de datos entre pantallas y
conexión con un **backend .NET que corre en Docker**.

Es el primer prototipo de *NutriPlan*, una app de menús personalizados: el usuario
completa su perfil y la app calcula su gasto energético con la fórmula de
**Mifflin-St Jeor**, tanto en la app como en el servidor, y compara ambos resultados.

**Autor:** José Miguel García

## Funcionalidades

- Navegación con GoRouter: rutas `/`, `/perfil`, `/menu`, `/mercado` y `/resultado`.
- Diferencia entre `context.go` (reemplaza la ruta) y `context.push` (apila la pantalla).
- Pantalla de error para rutas inexistentes (`errorBuilder`).
- Drawer reutilizable que resalta la pantalla actual.
- Formulario de perfil con `Form`, `TextFormField`, `DropdownButtonFormField` y validaciones.
- Envío de datos a otra pantalla con `extra` de GoRouter.
- Cálculo de GER y GET en la app (modelo `Perfil`) y en una API .NET en Docker.
- Manejo de errores de red: servidor apagado, tiempo agotado y botón de reintento.
- Pruebas automáticas: 1 prueba de widget y 5 pruebas unitarias del cálculo.

## Tecnologías

| Herramienta | Versión usada |
|---|---|
| Flutter / Dart | 3.47.3 / 3.13.3 |
| go_router, http | ver `pubspec.yaml` |
| .NET SDK | 10.0 |
| Docker / Docker Compose | 29.7 |

## Estructura del proyecto

```
lib/
├─ main.dart               # punto de entrada
├─ app.dart                # MaterialApp.router y tema
├─ router/app_router.dart  # rutas de GoRouter
├─ models/perfil.dart      # datos del usuario + fórmulas
├─ services/api_service.dart  # comunicación HTTP con la API
├─ screens/                # pantallas (inicio, perfil, resultado, menú, mercado)
└─ widgets/app_drawer.dart # menú lateral reutilizable
backend/NutriPlan.Api/     # API .NET (Program.cs, Dockerfile)
docker-compose.yml         # levanta la API con un comando
test/                      # pruebas de widget y unitarias
```

## Cómo ejecutar el proyecto

### Requisitos

- Flutter SDK (ejecutar `flutter doctor` y comprobar que Android esté en verde).
- Android Studio con un emulador creado.
- Docker Desktop encendido.

### Pasos

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/JOSEGZ1038/nutriplan_app.git
   cd nutriplan_app
   ```
2. Levantar la API en Docker:
   ```bash
   docker compose up --build -d
   ```
   Comprobar que responde: abrir http://localhost:8080/api/salud en el navegador.
3. Instalar las dependencias de Flutter:
   ```bash
   flutter pub get
   ```
4. Abrir el emulador Android y ejecutar la app:
   ```bash
   flutter run
   ```

> **Nota:** desde el emulador Android la app llama a `http://10.0.2.2:8080`, que es
> la dirección con la que el emulador ve al computador. En Windows o web usa
> `localhost:8080`.

### Ejecutar las pruebas

```bash
flutter test
```

Resultado esperado: `All tests passed!` (6 pruebas). Las pruebas unitarias verifican
el caso de referencia: 30 años, 70 kg, 170 cm → GER 1618 kcal (hombre) y 1452 kcal (mujer).

### Probar la API manualmente

```bash
curl -X POST http://localhost:8080/api/energia -H "Content-Type: application/json" -d "{\"edad\":30,\"pesoKg\":70,\"estaturaCm\":170,\"sexo\":\"masculino\",\"actividad\":\"sedentario\"}"
```

### Detener la API

```bash
docker compose down
```

## Cómo probar la app

1. **Inicio:** probar los botones `push`, `go`, `pushNamed` y "ruta inexistente".
2. **Drawer (☰):** navegar entre pantallas; la opción actual aparece resaltada.
3. **Mi perfil:** pulsar *Calcular* vacío para ver las validaciones, y luego llenar
   30 / 70 / 170 / Masculino / Sedentario.
4. **Resultado:** GER 1618 y GET 1941; la tarjeta del servidor debe decir
   "✔ Coincide con el cálculo de la app".
5. **Servidor apagado:** `docker compose stop`, volver y calcular de nuevo → tarjeta
   roja. Luego `docker compose start` y pulsar 🔄.

## Relación con los videos del curso

| Video | Qué se aplicó |
|---|---|
| BONUS – Automatización de contenedores Docker | `Dockerfile` de dos etapas y `docker-compose.yml` |
| FLUTTER_01 – Conectividad con Docker | `ApiService`, `10.0.2.2`, `usesCleartextTraffic` en debug |
| FLUTTER_02 – Inicio rápido | `flutter create`, estructura base, `main.dart` / `app.dart` |
| FLUTTER_03 – Estructura y navegación | carpetas por responsabilidad, GoRouter, `go` vs `push` |
| FLUTTER_04 – Drawer | `AppDrawer` reutilizable con GoRouter |
| FLUTTER_05 – Navegación y formularios | `Form`, validaciones, envío de datos con `extra` |

## Qué aprendí y desafíos

<!-- Escribe esto con TUS palabras. Algunos desafíos reales de este proyecto: -->
- Diferencia entre `go` y `push`, y cómo afecta al botón de volver.
- Archivos compilados en Windows (`obj/`) que se colaban en el contenedor Linux;
  se resolvió con un `.dockerignore` en la carpeta correcta.
- Redondeo distinto entre C# y Dart (1451,5): se usó `MidpointRounding.AwayFromZero`.
- El emulador no ve `localhost` de la PC: hay que usar `10.0.2.2`.

## Aviso

El cálculo es una estimación con fines educativos y no reemplaza la valoración de un
profesional de la nutrición.