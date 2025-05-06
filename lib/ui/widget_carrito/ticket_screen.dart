import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/others/generate_pdf.dart';

class TicketScreen extends ConsumerWidget {
  final String distrito;
  final double total;
  final String fechaHora;
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> productos;
  final double orderCostoEnvio;
  final String orderStatus;
  final int orderID;
  final String orderMethod;
  final Map<String, dynamic> sucursalTicket;

  const TicketScreen({
    super.key,
    required this.distrito,
    required this.total,
    required this.userData,
    required this.fechaHora,
    required this.productos,
    required this.orderCostoEnvio,
    required this.orderStatus,
    required this.orderID,
    required this.orderMethod,
    required this.sucursalTicket,
  });

  String formattedOrderID(int orderID) {
    final idStr = orderID.toString().padLeft(8, '0');
    return '${idStr.substring(0, 4)}-${idStr.substring(4)}';
  }

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener la hora actual en UTC-5 (Perú)
    final now = DateTime.now().toUtc().add(const Duration(hours: -5));
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    final formattedTime =
        "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF3391FA)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBusinessInfo(),
            const SizedBox(height: 10),
            _buildSucursalInfo(),
            const SizedBox(height: 10),
            _buildCompraResumen(),
            const SizedBox(height: 20),
            _buildBackButton(context),
            const SizedBox(height: 10),
            _buildDownloadPDFButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfo() {
    // Obtener la hora actual en UTC-5 (Perú)
    final now = DateTime.now().toUtc().add(const Duration(hours: -5));
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    final formattedTime =
        "${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userData['rubro'] ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Center(
          child: Column(
            children: [
              Text(
                userData['business_name'] ?? 'GYM FREED',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                userData['address'] ?? 'Los Olivos',
                style: const TextStyle(fontSize: 14), // Más pequeño
                textAlign: TextAlign.center,
              ),
              Text(
                userData['district'] ??
                    'jiron pachacutec  505 urbanizacion tahuantinsuyo',
                style: const TextStyle(fontSize: 14), // Más pequeño
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Text(userData['address'] ?? '', style: const TextStyle(fontSize: 16)),
        Text(userData['district'] ?? '', style: const TextStyle(fontSize: 16)),
        Text('RUC ${userData['ruc'] ?? '1014258963214'}',
            style: const TextStyle(fontSize: 16)),
        Text('N° Orden: ${formattedOrderID(orderID)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Fecha: $formattedDate',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                'Hora: $formattedTime',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSucursalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Método de Pago: $orderMethod',
            style: const TextStyle(fontSize: 16)),
        Text('Sucursal: ${sucursalTicket['nombre'] ?? "Los Olivos"}',
            style: const TextStyle(fontSize: 16)),
        Text(
            'Dirección: ${sucursalTicket['direccion'] ?? "jiron pachacutec  505 urbanizacion tahuantinsuyo"}',
            style: const TextStyle(fontSize: 16)),
        if (orderMethod != 'enGym')
          Text('Distrito de Envío: $distrito',
              style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildCompraResumen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text('Lista de productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        const Divider(thickness: 1),
        Row(
          children: const [
            Expanded(
                child: Center(
                    child: Text("Producto",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(
                child: Center(
                    child: Text("Cant.",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(
                child: Center(
                    child: Text("Categ.",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(
                child: Center(
                    child: Text("Delivery",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(
                child: Center(
                    child: Text("Precio",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(
                child: Center(
                    child: Text("Subtotal",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
          ],
        ),
        const SizedBox(height: 5),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final p = productos[index];
            final previousPrice = (p["previousPrice"] ?? 0).toDouble();
            final cantidad = (p["qty"] ?? 0).toInt();
            final subtotal = cantidad * previousPrice;
            final orderStatus = orderCostoEnvio;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text(p["name"] ?? "-"))),
                  Expanded(child: Center(child: Text("$cantidad"))),
                  Expanded(
                      child: Center(child: Text(p["tipo_categoria"] ?? "-"))),
                  Expanded(
                      child: Center(
                    child: Text("$orderCostoEnvio"),
                  )),
                  Expanded(
                      child: Center(
                          child:
                              Text("S/ ${previousPrice.toStringAsFixed(2)}"))),
                  Expanded(
                      child: Center(
                          child: Text("S/ ${subtotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                ],
              ),
            );
          },
        ),
        const Divider(thickness: 1),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildResumenLinea("SubTotal:", total),
            if (orderCostoEnvio > 0)
              _buildResumenLinea("Costo Envío:", orderCostoEnvio),
            _buildResumenLinea("Total:", total + orderCostoEnvio),
          ],
        ),
        const Divider(thickness: 1),
        Center(
          child: Text(orderStatus,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildResumenLinea(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text("S/ ${value.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3391FA),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child:
          const Text("Volver al inicio", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildDownloadPDFButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Verificar y formatear los productos
          final productosFormateados = productos.map((p) {
            return {
              'name': p['name'] ?? 'Producto sin nombre',
              'qty': p['qty'] ?? 0,
              'tamaño': p['tamaño'] ?? 'small',
              'tipo_categoria': p['tipo_categoria'] ?? 'Sin categoría',
              'previousPrice': (p['previousPrice'] ?? 0.0).toDouble(),
            };
          }).toList();

          await generarPDF(
            distrito: distrito,
            total: total,
            fechaHora: fechaHora,
            userData: userData,
            productos: productosFormateados,
            orderCostoEnvio: orderCostoEnvio,
            orderStatus: orderStatus,
            orderID: orderID,
            orderMetodo: orderMethod,
            orderSucursal: sucursalTicket,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al generar PDF: ${e.toString()}')),
          );
          print('Error al generar PDF: $e');
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text("Compartir Ticket PDF",
          style: TextStyle(color: Colors.white)),
    );
  }
}
