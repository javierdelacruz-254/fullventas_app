import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pases_libre_data.dart';
import 'package:intl/intl.dart';

class DetailPaseLibrePage extends ConsumerWidget {
  final PasesLibreData pase;

  const DetailPaseLibrePage({super.key, required this.pase});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(colorHex),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              utf8.decode(latin1.encode(pase.NombrePase ?? 'Sin nombre')),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: hexToColor(colorHex),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              utf8.decode(latin1.encode(pase.Descripcion ?? 'Sin descripción')),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.blueGrey),
                const SizedBox(width: 5),
                Text(
                  'Inicio: ${pase.FechaCanjeInicio != null ? DateFormat('dd/MM/yyyy').format(pase.FechaCanjeInicio!) : 'No disponible'}',
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.event, color: Colors.blueGrey),
                const SizedBox(width: 5),
                Text(
                  'Fin: ${pase.FechaCanjeFinal != null ? DateFormat('dd/MM/yyyy').format(pase.FechaCanjeFinal!) : 'No disponible'}',
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.inventory, color: Colors.blueGrey),
                const SizedBox(width: 5),
                Text(
                  'Stock Disponible: ${pase.StockDisponible ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: pase.Estado == 1
                    ? hexToColor(secondColor)
                    : Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      pase.Estado == 1 ? hexToColor(colorHex) : Colors.blueGrey,
                ),
              ),
              child: Text(
                pase.Estado == 1 ? 'Activo' : 'Inactivo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      pase.Estado == 1 ? hexToColor(colorHex) : Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes agregar la acción de inscripción
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hexToColor(colorHex),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Inscribirse',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
