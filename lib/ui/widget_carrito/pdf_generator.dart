import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<void> generarPDF({
  required String distrito,
  required double total,
  required String fechaHora,
  required Map<String, dynamic> userData,
  required List<Map<String, dynamic>> productos,
  required double orderCostoEnvio,
  required String orderStatus,
  required int orderID,
  required String orderMetodo,
  required Map<String, dynamic> orderSucursal,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              userData['business_name'] ?? 'Negocio',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text('RUC: ${userData['ruc'] ?? ''}'),
          pw.Text(
              'Central: ${userData['distrito_nombre']}, ${userData['address_gallery'] ?? ''}'),
          pw.Text(
              'Fecha: ${fechaHora.split(" ")[0]}  Hora: ${fechaHora.split(" ")[1]}'),
          pw.Text('Método pago: ${orderMetodo}'),
          pw.Text('${orderSucursal['nombre']}, ${orderSucursal['direccion']}'),
          if (orderMetodo != 'enGym') pw.Text('Distrito de Envio: $distrito'),
          pw.SizedBox(height: 10),
          pw.Text('N° Orden: ${orderID.toString().padLeft(8, '0')}'),
          pw.SizedBox(height: 10),
          pw.Text('Lista de productos',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Padding(
                    child: pw.Text('Producto', textAlign: pw.TextAlign.center),
                    padding: pw.EdgeInsets.all(5)),
                pw.Padding(
                    child: pw.Text('Cant.', textAlign: pw.TextAlign.center),
                    padding: pw.EdgeInsets.all(5)),
                pw.Padding(
                    child: pw.Text('Tamaño', textAlign: pw.TextAlign.center),
                    padding: pw.EdgeInsets.all(5)),
                pw.Padding(
                    child: pw.Text('Precio', textAlign: pw.TextAlign.center),
                    padding: pw.EdgeInsets.all(5)),
                pw.Padding(
                    child: pw.Text('Subtotal', textAlign: pw.TextAlign.center),
                    padding: pw.EdgeInsets.all(5)),
              ]),
              ...productos.map((producto) {
                final size = producto["size_nombre"];
                final precio = (producto["product_price"] ?? 0).toDouble();
                final cantidad = (producto["ordered_quantity"] ?? 0).toInt();
                final subtotal = cantidad * precio;
                return pw.TableRow(children: [
                  pw.Padding(
                      child: pw.Text(producto["product_nombre"] ?? "Producto"),
                      padding: pw.EdgeInsets.all(5)),
                  pw.Padding(
                      child:
                          pw.Text("$cantidad", textAlign: pw.TextAlign.center),
                      padding: pw.EdgeInsets.all(5)),
                  pw.Padding(
                      child: pw.Text("$size", textAlign: pw.TextAlign.center),
                      padding: pw.EdgeInsets.all(5)),
                  pw.Padding(
                      child: pw.Text("S/ ${precio.toStringAsFixed(2)}",
                          textAlign: pw.TextAlign.center),
                      padding: pw.EdgeInsets.all(5)),
                  pw.Padding(
                      child: pw.Text("S/ ${subtotal.toStringAsFixed(2)}",
                          textAlign: pw.TextAlign.center),
                      padding: pw.EdgeInsets.all(5)),
                ]);
              }).toList(),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('SubTotal: S/ ${total.toStringAsFixed(2)}'),
          pw.Text('Costo Envío: S/ ${orderCostoEnvio.toStringAsFixed(2)}'),
          pw.Text('Total: S/ ${(total + orderCostoEnvio).toStringAsFixed(2)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(orderStatus,
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
// Obtener el directorio de almacenamiento temporal
  final directory = await Directory.systemTemp.createTemp();
  final filePath = '${directory.path}/ticket_$orderID.pdf';

  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  print("PDF guardado en: ${file.path}");

  // Compartir el archivo
  await Share.shareXFiles([XFile(file.path)],
      text: "Aquí tienes tu ticket de compra");
}
