import 'package:flutter/material.dart';
import 'package:fullventas_app/ui/widget_carrito/pdf_generator.dart';

class TicketScreen extends StatelessWidget {
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

  TicketScreen({
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
    String idStr =
        orderID.toString().padLeft(8, '0'); // Asegura que tenga 8 dígitos
    return '${idStr.substring(0, 4)}-${idStr.substring(4, 8)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3391FA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBusinessInfo(),
            SizedBox(height: 10),
            _buildSucursalInfo(),
            SizedBox(height: 10.0),
            _buildCompraResumen(),
            SizedBox(height: 20),
            _buildBackButton(context),
            SizedBox(height: 20),
            _buildDownloadPDFButton(context),
          ],
        ),
      ),
    );
  }

  // Sección de información del negocio
  Widget _buildBusinessInfo() {
    return Column(
      children: [
        Text(userData['rubro_descripcion'] ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(userData['business_name'] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(userData['address_gallery'] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(userData['distrito_nombre'] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('RUC ${userData['ruc'] ?? ''}', style: TextStyle(fontSize: 16)),
        Text('N° Orden ${formattedOrderID(orderID)}',
            style: TextStyle(fontSize: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Fecha: ${fechaHora.split(" ")[0]}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Hora: ${fechaHora.split(" ")[1]}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildSucursalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text('Método de Pago: $orderMethod',
                style: TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          children: [
            Text(sucursalTicket['nombre'], style: TextStyle(fontSize: 16))
          ],
        ),
        Row(
          children: [
            Text('Dirección de Sucursal: ${sucursalTicket['direccion']}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
        if (orderMethod != 'enGym')
          Row(
            children: [
              Text('Distrito de Envío: $distrito',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
      ],
    );
  }

  // Sección de resumen de compra
  Widget _buildCompraResumen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Lista de productos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text("Producto",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Cant.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Tamaño",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Precio",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  child: Text("Subtotal",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final producto = productos[index];
            final String size = producto["size_nombre"];
            final double precio = (producto["product_price"] ?? 0).toDouble();
            final int cantidad = (producto["ordered_quantity"] ?? 0).toInt();
            final double subtotal = cantidad * precio;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(producto["product_nombre"] ?? "Producto",
                          textAlign: TextAlign.center)),
                  Expanded(
                      child: Text("$cantidad", textAlign: TextAlign.center)),
                  Expanded(child: Text("$size", textAlign: TextAlign.center)),
                  Expanded(
                      child: Text("S/ ${precio.toStringAsFixed(2)}",
                          textAlign: TextAlign.center)),
                  Expanded(
                      child: Text("S/ ${subtotal.toStringAsFixed(2)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            );
          },
        ),
        Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text("SubTotal:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("S/ ${total.toStringAsFixed(2)}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text("Costo Envío:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("S/ ${orderCostoEnvio.toStringAsFixed(2)}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text("Total:",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("S/ ${(orderCostoEnvio + total).toStringAsFixed(2)}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Divider(),
        Center(
          child: Text(
            orderStatus,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Botón para volver al inicio
  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3391FA),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        child: Text("Volver al inicio", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDownloadPDFButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await generarPDF(
          distrito: distrito,
          total: total,
          fechaHora: fechaHora,
          userData: userData,
          productos: productos,
          orderCostoEnvio: orderCostoEnvio,
          orderStatus: orderStatus,
          orderID: orderID,
          orderMetodo: orderMethod,
          orderSucursal: sucursalTicket,
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child:
          Text("Compartir Ticket PDF", style: TextStyle(color: Colors.white)),
    );
  }
}
