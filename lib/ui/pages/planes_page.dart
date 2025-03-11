import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/planes_data_provider.dart';
import 'package:fullventas_app/ui/widget_planes/carrusel_planes.dart';
import 'package:fullventas_app/ui/widget_planes/list_planes.dart';

class PlanesPage extends ConsumerWidget {
  const PlanesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlanesDetailUseCase = ref.watch(planesDataProvider);
    final searchQuery = ref.watch(searchQueryPlanes);

    return Scaffold(
      backgroundColor: Color(0xFF3391FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF3391FA),
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
              color: Color(0xFF3391FA),
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
              color: Color(0xFFB1D8F1),
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

            Container(
              width: double.infinity,
              color: Color(0xFF3391FA),
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
          ],
        ),
      ),
    );
  }
}
