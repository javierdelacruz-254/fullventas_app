import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/sucursales_data_Provder.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sucursales_data.dart';
import 'package:fullventas_app/ui/widget_sucursales/full_screen_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class ListSucursales extends ConsumerWidget {
  const ListSucursales({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final SucursalesDetailUseCase = ref.watch(sucursalesDataProvider);
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return FutureBuilder<List<SucursalesData>>(
      future: SucursalesDetailUseCase.getSucursalesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final sucursales = snapshot.data!;

          return sucursales.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: sucursales.length,
                  itemBuilder: (context, index) {
                    final sucursal = sucursales[index];
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                sucursal.nombre ?? 'Sin nombres',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: hexToColor(colorHex),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: 150,
                                    child: (sucursal.latitud != null &&
                                            sucursal.longitud != null)
                                        ? FlutterMap(
                                            options: MapOptions(
                                                initialCenter: LatLng(
                                                  double.parse(
                                                      sucursal.latitud!),
                                                  double.parse(
                                                      sucursal.longitud!),
                                                ),
                                                initialZoom: 16.0,
                                                interactionOptions:
                                                    InteractionOptions(
                                                        flags: InteractiveFlag
                                                            .none)),
                                            children: [
                                              TileLayer(
                                                urlTemplate:
                                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                subdomains: ['a', 'b', 'c'],
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: LatLng(
                                                      double.parse(
                                                          sucursal.latitud!),
                                                      double.parse(
                                                          sucursal.longitud!),
                                                    ),
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: Icon(
                                                      Icons.location_pin,
                                                      color: Colors.red,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: Text(
                                                "Ubicación no disponible")),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: FloatingActionButton(
                                    mini: true,
                                    backgroundColor: hexToColor(colorHex),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            DraggableScrollableSheet(
                                          initialChildSize: 0.7,
                                          minChildSize: 0.4,
                                          maxChildSize: 0.9,
                                          expand: false,
                                          builder: (context, scrollController) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              child: FullScreenMap(
                                                  latitud: double.parse(
                                                      sucursal.latitud!),
                                                  longitud: double.parse(
                                                      sucursal.longitud!),
                                                  nombre: sucursal.nombre ??
                                                      "Sucursal"),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            /*GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenMap(
                                      latitud: double.parse(sucursal.latitud!),
                                      longitud:
                                          double.parse(sucursal.longitud!),
                                      nombre: sucursal.nombre ?? "Sucursal",
                                    ),
                                  ),
                                );
                              },
                              child: 
                            ),*/
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.location_on,
                                        color: Colors.red),
                                    title: Text(
                                        sucursal.direccion ?? 'Sin dirección'),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.email,
                                        color: hexToColor(colorHex)),
                                    title:
                                        Text(sucursal.correo ?? 'Sin correo'),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading:
                                        Icon(Icons.phone, color: Colors.green),
                                    title:
                                        Text(sucursal.celular ?? 'Sin celular'),
                                  ),
                                ],
                              ),
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
