import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Cambia esta URL por la IP y puerto donde corre tu Flask (ej. http://192.168.15.XXX:5003)
  static const String baseUrl = 'http://192.168.15.253:5003/api';

  // --- LOGIN ---
  static Future<Map<String, dynamic>> login(String usuario, String clave) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': usuario, 'pass': clave}),
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // --- HOJA DE RUTA ---
  static Future<Map<String, dynamic>> getHojaRuta(String fecha, String idPersona) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hoja-ruta?fecha=$fecha&id_persona=$idPersona'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // --- GUARDAR PEDIDO ---
  static Future<Map<String, dynamic>> guardarPedido(Map<String, dynamic> pedidoData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/guardar-pedido'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pedidoData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }
}
