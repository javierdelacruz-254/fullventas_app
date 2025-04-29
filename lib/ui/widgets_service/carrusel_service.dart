import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/services_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarruselService extends ConsumerWidget {
  const CarruselService({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ServicesDetailUseCase = ref.watch(servicesDataProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return FutureBuilder<List<ServicesData>>(
      future: ServicesDetailUseCase.getServicesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final services = snapshot.data!;

          if (services.isEmpty) {
            return Center(child: Text('No hay servicios disponibles'));
          }

          if (services.length == 1) {
            final service = services.first;
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(service.imageName!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      color: hexToColor(colorHex),
                      width: double.infinity,
                      child: Text(
                        utf8.decode(
                            latin1.encode(service.title ?? 'Sin nombre')),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: services.map((service) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(service.imageName!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            color: hexToColor(colorHex),
                            width: double.infinity,
                            child: Text(
                              utf8.decode(latin1
                                  .encode(service.title ?? 'Sin nombres')),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}
