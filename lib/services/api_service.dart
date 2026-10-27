import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.15.253:5000/api';

  static Future<Map<String, dynamic>?> login(String usuario, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "password": password}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (_) {}
    return null;
  }

  static Future<List<dynamic>> getHojaRuta(String fecha, int idPersona) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/hoja-ruta?fecha=$fecha&id_persona=$idPersona'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'] ?? [];
      }
    } catch (_) {}
    return [];
  }

  static Future<List<dynamic>> getDetalleDeuda(int idCliente) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/hoja-ruta/detalle?id_cliente=$idCliente'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'] ?? [];
      }
    } catch (_) {}
    return [];
  }
}
B. Menú Principal con Opcion
