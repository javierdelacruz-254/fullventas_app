import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/estrategia_ventas_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';
import 'package:fullventas_app/ui/detail_pages/detail_estrategia_venta_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ListEstrategiaVentas extends ConsumerWidget {
  const ListEstrategiaVentas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EstrategiaVentasDetailUseCase =
        ref.watch(estrategiaVentasDataProvider);

    return FutureBuilder<List<EstrategiaVentasData>>(
        future: EstrategiaVentasDetailUseCase.getEstrategiaVentasData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No se encontró información'));
          } else {
            final estrategiaVentas = snapshot.data!;
            return estrategiaVentas.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                      width: double.infinity,
                      color: Color(0xFF3391FA),
                      padding: EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: estrategiaVentas.length,
                        itemBuilder: (context, index) {
                          final estrategia = estrategiaVentas[index];

                          bool estaExpirada = _isExpired(estrategia.fecha_fin);

                          return GestureDetector(
                              onTap: () {
                                if (estaExpirada) {
                                  dialog(context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailEstrategiaVentaPage(
                                              estrategiaVentasData: estrategia),
                                    ),
                                  );
                                }
                              },
                              child: Opacity(
                                opacity: estaExpirada ? 0.5 : 1.0,
                                child: Card(
                                  margin: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          child: Image.network(
                                            estrategia.image_name ?? '',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: double.infinity,
                                                height: 120,
                                                color: Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey.shade600,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              utf8.decode(latin1.encode(
                                                  estrategia.title ??
                                                      'Sin títutlo')),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 4),
                                            // Precio anterior
                                            Row(
                                              children: [
                                                Text(
                                                  'S/${estrategia.precio_normal!.toStringAsFixed(2) ?? 0}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            if (estaExpirada)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  'Promocion caducada',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  );
          }
        });
  }

  bool _isExpired(DateTime? fechaFin) {
    if (fechaFin == null) return false;

    if (fechaFin.year < 1) {
      return false;
    }

    return DateTime.now().isAfter(fechaFin);
  }

  void dialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Oferta no disponible',
      desc: 'Esta oferta ya no está disponible.',
      btnOkText: 'Entendido',
      btnOkOnPress: () {},
    ).show();
  }
}
