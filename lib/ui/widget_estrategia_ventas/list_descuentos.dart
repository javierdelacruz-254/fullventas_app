import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/descuentos_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/descuentos_data.dart';
import 'package:fullventas_app/ui/detail_pages/detail_descuento_page.dart';

class ListDescuentos extends ConsumerWidget {
  const ListDescuentos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DescuentosDetailUseCase = ref.watch(descuentosDataProvider);

    return FutureBuilder<List<DescuentosData>>(
      future: DescuentosDetailUseCase.getDescuentosData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final descuentos = snapshot.data!;
          return descuentos.isEmpty
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
                        itemCount: descuentos.length,
                        itemBuilder: (context, index) {
                          final descuento = descuentos[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailDescuentoPage(
                                      descuentosData: descuento),
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Image.network(
                                        descuento.image_name ?? '',
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
                                              descuento.title ??
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
                                        if (descuento.precio_normal != null)
                                          Text(
                                            'Antes: S/${descuento.precio_normal!.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        // Precio anterior
                                        Row(
                                          children: [
                                            Text(
                                              'S/${descuento.precio_descuento!.toStringAsFixed(2) ?? 0}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                '-${(double.tryParse(descuento.porcentaje?.toString() ?? '0') ?? 0).toStringAsFixed(0)}%',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
        }
      },
    );
  }
}
