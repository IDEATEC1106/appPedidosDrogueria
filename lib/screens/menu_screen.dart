import 'package:flutter/material.dart';
import 'hoja_ruta_screen.dart';

class MenuScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  const MenuScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Droguería - Hola, ${userData['nombre']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _BotonMenu(
              titulo: 'Hoja de Ruta',
              icono: Icons.map,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HojaRutaScreen(idPersona: userData['id_persona'])),
              ),
            ),
            _BotonMenu(
              titulo: 'Registro de Pedidos',
              icono: Icons.add_shopping_cart,
              onTap: () {},
            ),
            _BotonMenu(
              titulo: 'Lista de Pedidos',
              icono: Icons.list_alt,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final VoidCallback onTap;
  const _BotonMenu({required this.titulo, required this.icono, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
