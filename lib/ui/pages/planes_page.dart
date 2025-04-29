import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/planes_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/ui/widget_planes/carrusel_planes.dart';
import 'package:fullventas_app/ui/widget_planes/list_planes.dart';

class PlanesPage extends ConsumerWidget {
  const PlanesPage({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlanesDetailUseCase = ref.watch(planesDataProvider);
    final searchQuery = ref.watch(searchQueryPlanes);
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return Scaffold(
      backgroundColor: hexToColor(colorHex),
      appBar: AppBar(
        backgroundColor: hexToColor(colorHex),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (query) =>
                ref.read(searchQueryPlanes.notifier).state = query,
            decoration: InputDecoration(
              hintText: "Buscar...",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: hexToColor(colorHex),
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "MEMEBRESIAS Y PLANES",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            //-------------------
            //CARRUSEL DE PRODUCTOS
            //-------------------
            Container(
              width: double.infinity,
              color: hexToColor(secondColor),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: CarruselPlanes(),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 440,
              height: 140,
              child: Image.asset(
                'assets/img/img_pesas.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              color: hexToColor(colorHex),
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Explorar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListPlanes(),
            SizedBox(
              width: 339,
              height: 200,
              child: Image.asset(
                'assets/img/img_pesas.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
