import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/estrategia_ventas_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';

class CarruselEstrategiaVentas extends ConsumerWidget {
  const CarruselEstrategiaVentas({super.key});

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
                : CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: estrategiaVentas.map((estrategia) {
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
                                      image:
                                          NetworkImage(estrategia.image_name!),
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
                                    color: Color(0xFF3391FA),
                                    width: double.infinity,
                                    child: Text(
                                      utf8.decode(latin1.encode(
                                          estrategia.title ?? 'Sin nombres')),
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
        });
  }
}
