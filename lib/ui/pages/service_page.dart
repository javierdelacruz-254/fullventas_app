import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/services_data_provider.dart';
import 'package:fullventas_app/ui/widgets_service/carrusel_service.dart';
import 'package:fullventas_app/ui/widgets_service/list_service.dart';

class ServicePage extends ConsumerWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ServicesDetailUseCase = ref.watch(servicesDataProvider);
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
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
                    "SERVICIOS",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              //-------------------
              //CARRUSEL DE SERVICIOS
              //-------------------
              Container(
                width: double.infinity,
                color: Color(0xFFB1D8F1),
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: CarruselService(),
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

              //-------------------
              //LISTADO DE SERVICIOS
              //-------------------
              ListService(),
            ],
          ),
        ));
  }
}
