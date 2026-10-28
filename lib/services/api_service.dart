import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base de tu servidor backend en Flask
  static const String baseUrl = 'http://38.224.68.171:5003/api';

  // 1. Método para iniciar sesión (POST con JSON en el body)
  static Future<Map<String, dynamic>> login(String usuario, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login": usuario,
          "clave": contrasena,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "message": errorData["message"] ?? "Error en el servidor: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: $e"
      };
    }
  }

  // 2. Método para obtener la hoja de ruta (GET con parámetros en la URL)
  static Future<Map<String, dynamic>> getHojaRuta(String fecha, String idPersona) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hoja-ruta?fecha=$fecha&id_persona=$idPersona'),
        headers: {"Content-Type": "application/json"},
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

  // 3. Método para obtener el detalle de las facturas adeudadas por cliente (GET)
  static Future<Map<String, dynamic>> getHojaRutaDetalle(String idCliente) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hoja-ruta/detalle?id_cliente=$idCliente'),
        headers: {"Content-Type": "application/json"},
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

  // 4. Método para guardar un pedido (POST con JSON en el body)
  static Future<Map<String, dynamic>> guardarPedido(Map<String, dynamic> datosPedido) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/guardar-pedido'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datosPedido),
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
