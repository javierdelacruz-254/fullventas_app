import 'dart:io';
import 'package:pdf/pdf.dart';
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

  DateTime nowUtcMinus5 = DateTime.now().toUtc().subtract(Duration(hours: 5));
  String fechaStr =
      "${nowUtcMinus5.year}-${nowUtcMinus5.month.toString().padLeft(2, '0')}-${nowUtcMinus5.day.toString().padLeft(2, '0')}";
  String horaStr =
      "${nowUtcMinus5.hour.toString().padLeft(2, '0')}:${nowUtcMinus5.minute.toString().padLeft(2, '0')}";

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              userData['business_name']?.toString() ?? 'gym freed',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue400,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text('RUC: ${userData['ruc'] ?? '1014258963214'}',
              style: pw.TextStyle(fontSize: 12)),
          pw.Text(
              'Dirección: ${userData['useraddress'] ?? " jiron pachacutec  505 urbanizacion tahuantinsuyo  "}',
              style: pw.TextStyle(fontSize: 12)),
          pw.Text('Distrito: ${userData['distric'] ?? 'ate'}',
              style: pw.TextStyle(fontSize: 12)),
          pw.Text('Fecha: $fechaStr  Hora: $horaStr',
              style: pw.TextStyle(fontSize: 12)),
          pw.Divider(thickness: 1),
          pw.Text('N° Orden: ${orderID.toString().padLeft(8, '0')}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Método pago: ${orderMetodo.toUpperCase()}',
              style: pw.TextStyle(fontSize: 12)),
          pw.Text(
              'Sucursal: ${orderSucursal['nombre'] ?? 'Sucursal los Olivos'}',
              style: pw.TextStyle(fontSize: 12)),
          if (orderMetodo != 'enGym')
            pw.Text('Distrito de Envío: $distrito',
                style: pw.TextStyle(fontSize: 12)),
          pw.Divider(thickness: 1),
          pw.Text('DETALLE DE PRODUCTOS',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          if (productos.isEmpty)
            pw.Text("No hay productos para mostrar.",
                style: pw.TextStyle(fontSize: 12))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1.5),
                3: pw.FlexColumnWidth(1.5),
                4: pw.FlexColumnWidth(1.2),
                5: pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildTableCell('Producto', isHeader: true),
                    _buildTableCell('Cant.', isHeader: true, center: true),
                    _buildTableCell('tamaño', isHeader: true, center: true),
                    //  _buildTableCell('Tamaño', isHeader: true, center: true),
                    _buildTableCell('Precio', isHeader: true, center: true),
                    _buildTableCell('Subtotal', isHeader: true, center: true),
                  ],
                ),
                ...productos.map((producto) {
                  final name = producto["name"]?.toString() ?? 'Producto';
                  final size = producto["size_nombre"]?.toString() ?? 'small';
                  final previousPrice =
                      (producto["previousPrice"] ?? 0).toDouble();
                  final qty = (producto["qty"] ?? 0).toInt();
                  final subtotal = qty * previousPrice;

                  return pw.TableRow(
                    children: [
                      _buildTableCell(name),
                      _buildTableCell('$qty', center: true),
                      _buildTableCell(size, center: true),
                      _buildTableCell('S/ ${previousPrice.toStringAsFixed(2)}',
                          center: true),
                      _buildTableCell('S/ ${subtotal.toStringAsFixed(2)}',
                          center: true),
                    ],
                  );
                }).toList(),
              ],
            ),
          pw.SizedBox(height: 15),
          _buildTotalLine('SUBTOTAL:', total),
          if (orderCostoEnvio > 0)
            _buildTotalLine('COSTO ENVÍO:', orderCostoEnvio),
          _buildTotalLine('TOTAL:', total + orderCostoEnvio,
              isBold: true, textColor: PdfColors.blue400),
          pw.SizedBox(height: 15),
          pw.Center(
            child: pw.Container(
              padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: pw.BoxDecoration(
                color: orderStatus.toLowerCase().contains('pagado')
                    ? PdfColors.green
                    : PdfColors.red,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                orderStatus.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text(
              '¡Gracias por su compra!',
              style: pw.TextStyle(
                fontSize: 12,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  final directory = await Directory.systemTemp.createTemp();
  final filePath = '${directory.path}/ticket_$orderID.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  await Share.shareXFiles(
    [XFile(file.path)],
    text: "Ticket de compra #$orderID - ${userData['business_name'] ?? ''}",
  );
}

pw.Padding _buildTableCell(String text,
    {bool isHeader = false, bool center = false}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    child: pw.Text(
      text,
      textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Row _buildTotalLine(String label, double value,
    {bool isBold = false, PdfColor? textColor}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: textColor ?? PdfColors.black,
        ),
      ),
      pw.Text(
        'S/ ${value.toStringAsFixed(2)}',
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: textColor ?? PdfColors.black,
        ),
      ),
    ],
  );
}
