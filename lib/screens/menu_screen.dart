import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal - Droguería')),
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
              onTap: () {
                // TODO: Navegar a Hoja de Ruta
              },
            ),
            _BotonMenu(
              titulo: 'Registro de Pedidos',
              icono: Icons.add_shopping_cart,
              onTap: () {
                // Aquí iniciaremos la pantalla del carrito y selección de productos
              },
            ),
            _BotonMenu(
              titulo: 'Lista de Pedidos',
              icono: Icons.list_alt,
              onTap: () {
                // TODO: Ver Pendientes y Atendidos
              },
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
