import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/pases_libre_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pases_libre_data.dart';
import 'package:fullventas_app/ui/detail_pages/detail_pase_libre_page.dart';
import 'package:intl/intl.dart';

class ListPasesLibre extends ConsumerWidget {
  const ListPasesLibre({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PasesLibreDetailUseCase = ref.watch(paseslibreDataProvider);

    return FutureBuilder<List<PasesLibreData>>(
      future: PasesLibreDetailUseCase.getPasesLibresData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final paseslibres = snapshot.data!;

          return paseslibres.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: paseslibres.length,
                  itemBuilder: (context, index) {
                    final paselibre = paseslibres[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 10,
                      shadowColor: Color(0xFF3391FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  utf8.decode(latin1.encode(
                                      paselibre.NombrePase ?? 'Sin nombre')),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3391FA),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: paselibre.Estado == 1
                                              ? Color(0xFF3391FA)
                                              : Colors.blueGrey)),
                                  child: Text(
                                    paselibre.Estado == 1
                                        ? 'Activo'
                                        : 'Sin Estado',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: paselibre.Estado == 1
                                          ? Color(0xFF3391FA)
                                          : Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Descripcion: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3391FA)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    utf8.decode(
                                        latin1.encode(paselibre.Descripcion!)),
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Inicio: ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      paselibre.FechaCanjeInicio != null
                                          ? DateFormat('dd/MM/yyyy').format(
                                              paselibre.FechaCanjeFinal!)
                                          : 'Sin Fecha',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Fin: ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      paselibre.FechaCanjeFinal != null
                                          ? DateFormat('dd/MM/yyyy').format(
                                              paselibre.FechaCanjeFinal!)
                                          : 'Sin Fecha',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Stock Disponible: ${paselibre.StockDisponible ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPaseLibrePage(
                                                pase: paselibre),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3391FA),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Ver mas',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Color(0xFF3391FA)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Inscribirse',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF3391FA)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        }
      },
    );
  }
}
