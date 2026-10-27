import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Si usas emulador Android usa '10.0.2.2', si es dispositivo físico usa la IP de tu PC o red local
  static const String baseUrl = 'http://192.168.15.253:5000/api';

  static Future<Map<String, dynamic>?> login(String usuario, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return null;
    }
  }
}
