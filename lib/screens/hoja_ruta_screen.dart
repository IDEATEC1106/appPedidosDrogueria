import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HojaRutaScreen extends StatefulWidget {
  final int idPersona;
  const HojaRutaScreen({super.key, required this.idPersona});

  @override
  State<HojaRutaScreen> createState() => _HojaRutaScreenState();
}

class _HojaRutaScreenState extends State<HojaRutaScreen> {
  List<dynamic> clientes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarHojaRuta();
  }

  void _cargarHojaRuta() async {
    String fechaHoy = DateTime.now().toIso8601String().split('T')[0];
    var resultado = await ApiService.getHojaRuta(fechaHoy, widget.idPersona);
    setState(() {
      clientes = resultado;
      isLoading = false;
    });
  }

  void _mostrarDetalleFacturas(int idCliente, String razonSocial) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    var detalle = await ApiService.getDetalleDeuda(idCliente);
    Navigator.pop(context); // Cerrar loading

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Facturas de: $razonSocial'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: detalle.length,
            itemBuilder: (context, index) {
              var fac = detalle[index];
              return ListTile(
                title: Text('Factura: ${fac['numero_factura'] ?? fac['nfact']}'),
                subtitle: Text('Fecha: ${fac['fecha'] ?? ''}'),
                trailing: Text('Saldo: S/. ${fac['saldo'] ?? fac['total_adeudado']}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hoja de Ruta - Clientes del Día')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : clientes.isEmpty
              ? const Center(child: Text('No hay clientes asignados para hoy'))
              : ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    var cliente = clientes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(cliente['Razon_Social'] ?? cliente['nombre'] ?? 'Sin Nombre',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('RUC: ${cliente['RUC']} \nCant. Facturas: ${cliente['Cantidad'] ?? cliente['NFact']} | Deuda: S/. ${cliente['Total_Adeudado'] ?? cliente['saldo']}'),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          onPressed: () => _mostrarDetalleFacturas(cliente['id_cliente'], cliente['Razon_Social'] ?? 'Cliente'),
                          child: const Text('Ver Detalle'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
¿Te parece correcta esta estructura para ir implementando la Hoja de Ruta, o prefiere
