import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedidos Droguería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ==================== LOGIN SCREEN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _facerLogin() async {
    final usuario = _userController.text.trim();
    final clave = _passController.text.trim();

    if (usuario.isEmpty || clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese usuario y contraseña')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final resultado = await ApiService.login(usuario, clave);

    setState(() => _isLoading = false);

    if (resultado['success'] == true) {
      final user = resultado['user'];
      
      // Navegamos a la Hoja de Ruta pasando los datos del usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HojaRutaScreen(userData: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado['message'] ?? 'Error desconocido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_shipping, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Pedidos Droguería',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Usuario / Código',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _facerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('INGRESAR', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== HOJA DE RUTA SCREEN ====================
class HojaRutaScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HojaRutaScreen({super.key, required this.userData});

  @override
  State<HojaRutaScreen> createState() => _HojaRutaScreenState();
}

class _HojaRutaScreenState extends State<HojaRutaScreen> {
  bool _isLoading = true;
  List<dynamic> _clientes = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarHojaRuta();
  }

  void _cargarHojaRuta() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Obtenemos la fecha actual en formato YYYY-MM-DD
    final now = DateTime.now();
    final fechaHoy = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final idPersona = widget.userData['id_persona'].toString();

    final resultado = await ApiService.getHojaRuta(fechaHoy, idPersona);

    setState(() {
      _isLoading = false;
      if (resultado['success'] == true) {
        _clientes = resultado['data'] ?? [];
      } else {
        _errorMessage = resultado['message'] ?? 'Error al cargar la hoja de ruta';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nombreUsuario = widget.userData['nombre'] ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hoja de Ruta - $nombreUsuario'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarHojaRuta,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _clientes.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay clientes asignados para hoy',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = _clientes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.store, color: Colors.white),
                            ),
                            title: Text(
                              cliente['nombre'] ?? cliente['razon_social'] ?? 'Cliente sin nombre',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Dirección: ${cliente['direccion'] ?? 'Sin dirección'}',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Aquí luego podemos abrir el detalle de facturas o generar el pedido
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Seleccionaste a: ${cliente['nombre']}')),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
