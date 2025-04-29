import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/descuentos_data_provider.dart';
import 'package:fullventas_app/config/providers/estrategia_ventas_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/descuentos_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';

class CarruselEstrategiaVentas extends ConsumerWidget {
  const CarruselEstrategiaVentas({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EstrategiaVentasDetailUseCase =
        ref.watch(estrategiaVentasDataProvider);
    final DescuentosDetailUseCase = ref.watch(descuentosDataProvider);

    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        EstrategiaVentasDetailUseCase.getEstrategiaVentasData(),
        DescuentosDetailUseCase.getDescuentosData(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final List<EstrategiaVentasData> estrategiasVentas =
              snapshot.data![0];
          final List<DescuentosData> descuentos = snapshot.data![1];

          final totalItems = [...estrategiasVentas, ...descuentos];

          if (totalItems.isEmpty) {
            return const Center(child: Text('No hay elementos para mostrar'));
          }

          if (totalItems.length == 1) {
            return _buildItem(context, totalItems.first, colorHex);
          }

          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: totalItems.map((item) {
              return Builder(
                builder: (context) => _buildItem(context, item, colorHex),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, dynamic item, String colorHex) {
    String? imageUrl;
    String? title;

    if (item is EstrategiaVentasData) {
      imageUrl = item.image_name;
      title = item.title;
    } else if (item is DescuentosData) {
      imageUrl = item.image_name;
      title = item.title;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(imageUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              color: hexToColor(colorHex),
              child: Text(
                utf8.decode(latin1.encode(title ?? 'Sin nombre')),
                style: const TextStyle(
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
  }
}
