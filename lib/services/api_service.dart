import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform, SocketException;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/perfil.dart';

/// Respuesta del endpoint POST /api/energia de la API .NET.
class ResultadoServidor {
  final int gastoReposo;
  final int gastoTotal;
  final double factorActividad;
  final String formula;

  const ResultadoServidor({
    required this.gastoReposo,
    required this.gastoTotal,
    required this.factorActividad,
    required this.formula,
  });

  /// Crea el objeto a partir del JSON que devuelve el servidor.
  factory ResultadoServidor.fromJson(Map<String, dynamic> json) {
    return ResultadoServidor(
      gastoReposo: json['gastoReposo'] as int,
      gastoTotal: json['gastoTotal'] as int,
      // "as num" porque JSON puede traer 1 o 1.2; luego lo pasamos a double.
      factorActividad: (json['factorActividad'] as num).toDouble(),
      formula: json['formula'] as String,
    );
  }
}

/// Toda la comunicación con el backend está en esta clase.
class ApiService {
  /// Dirección del backend según dónde corre la app:
  /// - Emulador Android: 10.0.2.2 es "la PC" vista desde el emulador.
  /// - Windows / web: localhost.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  /// Envía el perfil a la API y devuelve el cálculo hecho en el servidor.
  static Future<ResultadoServidor> calcularEnergia(Perfil perfil) async {
    final http.Response respuesta;
    try {
      respuesta = await http
          .post(
            Uri.parse('$baseUrl/api/energia'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(perfil.toJson()),
          )
          .timeout(const Duration(seconds: 5)); // no esperar para siempre
    } on SocketException {
      throw Exception(
        'No se pudo conectar con $baseUrl. '
        '¿Está corriendo "docker compose up"?',
      );
    } on TimeoutException {
      throw Exception('El servidor no respondió a tiempo ($baseUrl).');
    } on http.ClientException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }

    if (respuesta.statusCode == 200) {
      return ResultadoServidor.fromJson(
        jsonDecode(respuesta.body) as Map<String, dynamic>,
      );
    }

    // Si el servidor rechazó los datos (400), la API envía {"error": "..."}.
    String mensaje = 'Error del servidor (${respuesta.statusCode})';
    try {
      mensaje = (jsonDecode(respuesta.body)['error'] as String?) ?? mensaje;
    } catch (_) {
      // el cuerpo no era JSON: dejamos el mensaje genérico
    }
    throw Exception(mensaje);
  }
}
