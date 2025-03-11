import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/slider_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/slider_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductCarousel extends ConsumerWidget {
  const ProductCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sliderDetailUseCase = ref.watch(sliderDataProvider);

    return FutureBuilder<List<SliderData>>(
      future: sliderDetailUseCase.getSliderData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final slider = snapshot.data!;

          return slider.isEmpty
              ? Center(child: CircularProgressIndicator())
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 252.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: slider.map((slider) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10.0), // Para redondear las esquinas
                          child: Stack(
                            fit: StackFit
                                .expand, // Asegura que la imagen y el cuadro ocupen
                            children: [
                              // Imagen principal
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(slider.image_name!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Cuadro negro transparente con el título
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  color: Colors.black
                                      .withOpacity(0.5), // Transparencia
                                  width: double
                                      .infinity, // Para que ocupe todo el ancho
                                  child: Text(
                                    slider.title!,
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
