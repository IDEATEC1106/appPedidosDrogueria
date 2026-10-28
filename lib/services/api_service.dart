import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base de tu servidor backend en Flask
  static const String baseUrl = 'http://38.224.68.171:5003/api';

  // 1. Método para iniciar sesión
  static Future<Map<String, dynamic>> login(String usuario, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": usuario,
          "contrasena": contrasena,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Error en el servidor: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: $e"
      };
    }
  }

  // 2. Método para obtener la hoja de ruta (requerido por main.dart)
  static Future<Map<String, dynamic>> getHojaRuta(String fecha, String idPersona) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hoja_ruta'), // Ajusta la ruta exacta si tu endpoint en Flask se llama diferente
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fecha": fecha,
          "id_persona": idPersona,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Error en el servidor: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: $e"
      };
    }
  }
}
