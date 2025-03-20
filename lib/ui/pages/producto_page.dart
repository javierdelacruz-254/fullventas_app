import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/products_data_provider.dart';
import 'package:fullventas_app/ui/pages/carrito_page.dart';
import 'package:fullventas_app/ui/widgets_products/carrusel_product.dart';
import 'package:fullventas_app/ui/widgets_products/list_product.dart';

class ProductoPage extends ConsumerWidget {
  const ProductoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ServicesDetailUseCase = ref.watch(productsDataProvider);
    final searchQuery = ref.watch(searchQueryProvider);

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
                ref.read(searchQueryProvider.notifier).state = query,
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
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarritoPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Consumer(
                  builder: (context, ref, child) {
                    final totalCantidad = ref
                        .watch(carritoProvider)
                        .fold(0, (sum, item) => sum + item['cantidad'] as int);

                    return totalCantidad > 0
                        ? CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 8,
                            child: Text(
                              totalCantidad
                                  .toString(), // Ahora muestra la cantidad real
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          )
                        : SizedBox(); // No mostrar si el carrito está vacío
                  },
                ),
              ),
            ],
          )
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
                  "PRODUCTOS",
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
                    child: CarruselProduct(),
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
            ListProduct(),
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
