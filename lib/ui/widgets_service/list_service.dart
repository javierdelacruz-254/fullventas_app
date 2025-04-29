import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/anuncios_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/services_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:fullventas_app/ui/detail_pages/detail_service_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ListService extends ConsumerWidget {
  const ListService({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  IconData? obtenerIconoRedSocial(String url) {
    if (url.contains("facebook")) return FontAwesomeIcons.facebook;
    if (url.contains("instagram")) return FontAwesomeIcons.instagram;
    if (url.contains("twitter")) return FontAwesomeIcons.twitter;
    if (url.contains("tiktok")) return FontAwesomeIcons.tiktok;
    return FontAwesomeIcons.link;
  }

  Future<void> executeUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  String obtenerNombreRedSocial(String red) {
    if (red.contains("facebook")) return 'Facebook';
    if (red.contains("instagram")) return 'Instagram';
    if (red.contains("twitter")) return 'Twitter';
    if (red.contains("tiktok")) return 'Tiktok';
    return 'Sin red';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ServicesDetailUseCase = ref.watch(servicesDataProvider);
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";
    final String colorTexto = screenData.isNotEmpty
        ? screenData.first.color_texto ?? "#FFFFFF"
        : "#FFFFFF";
    final String colorTextoSecond = screenData.isNotEmpty
        ? screenData.first.color_text_sec ?? "#FFFFFF"
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
          return services.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    width: double.infinity,
                    color: hexToColor(colorHex),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: services.length > 6 ? 6 : services.length,
                          itemBuilder: (context, index) {
                            final servicio = services[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailServicePage(
                                        servicesData: servicio),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: Image.network(
                                          servicio.imageName ?? '',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: double.infinity,
                                              height: 120,
                                              color: Colors.grey.shade300,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey.shade600,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            utf8.decode(latin1.encode(
                                                servicio.title ??
                                                    'Sin títutlo')),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4),
                                          // Precio anterior
                                          if (servicio.price != null)
                                            Text(
                                              'Antes: S/${servicio.price!.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          Row(
                                            children: [
                                              Text(
                                                'S/${servicio.previousPrice!.toStringAsFixed(2) ?? 0}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  '-${(double.tryParse(servicio.descuento?.toString() ?? '0') ?? 0).toStringAsFixed(0)}%',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        if (services.length > 6)
                          Consumer(
                            builder: (context, ref, _) {
                              final anuncioProvider =
                                  ref.watch(anunciosDataProvider);

                              return FutureBuilder<List<AnunciosData>>(
                                  future: anuncioProvider
                                      .getAnunciosBySeccion('Listado 2'),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Text(
                                          'No hay anuncios disponibles.');
                                    }

                                    final anuncios = snapshot.data!;

                                    if (anuncios.length == 1) {
                                      final anuncio = anuncios.first;
                                      return SizedBox(
                                        width: 440,
                                        height: 140,
                                        child: Image.network(
                                          anuncio.url_imagen!,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      return CarouselSlider(
                                        options: CarouselOptions(
                                            height: 140.0,
                                            autoPlay: true,
                                            enlargeCenterPage: true,
                                            viewportFraction: 1.0),
                                        items: anuncios.map((anuncio) {
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              anuncio
                                                                  .url_imagen!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    // Cuadro negro transparente con el título
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          final redes = anuncio
                                                                  .url_redes ??
                                                              [];

                                                          if (redes.length ==
                                                              1) {
                                                            executeUrl(
                                                                redes.first);
                                                          } else if (redes
                                                                  .length >
                                                              1) {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                                  false,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                            top:
                                                                                Radius.circular(20)),
                                                              ),
                                                              builder:
                                                                  (context) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                        'Elige una red para visitar',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      GridView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            redes.length,
                                                                        gridDelegate:
                                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                          crossAxisCount:
                                                                              4,
                                                                          mainAxisSpacing:
                                                                              20,
                                                                          crossAxisSpacing:
                                                                              20,
                                                                          childAspectRatio:
                                                                              0.8,
                                                                        ),
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          final red =
                                                                              redes[index];
                                                                          final icono =
                                                                              obtenerIconoRedSocial(red);
                                                                          final nombreRed =
                                                                              obtenerNombreRedSocial(red);

                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              executeUrl(red);
                                                                            },
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                CircleAvatar(
                                                                                  radius: 26,
                                                                                  backgroundColor: Colors.black12,
                                                                                  child: FaIcon(
                                                                                    icono,
                                                                                    size: 28,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 6),
                                                                                Text(
                                                                                  nombreRed,
                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: hexToColor(colorTextoSecond)),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        20.0),
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5), // Transparencia
                                                            width: double
                                                                .infinity, // Para que ocupe todo el ancho
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Siguenos en:',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  height: 10.0,
                                                                ),
                                                                if ((anuncio.url_redes ??
                                                                        [])
                                                                    .isNotEmpty)
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FaIcon(
                                                                          obtenerIconoRedSocial(anuncio
                                                                              .url_redes!
                                                                              .first),
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                        if (anuncio.url_redes!.length >
                                                                            1) ...[
                                                                          SizedBox(
                                                                              width: 8.0),
                                                                          Text(
                                                                            'ver más',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white70,
                                                                              fontSize: 14.0,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ]
                                                                      ])
                                                                else
                                                                  Text(
                                                                    'Sin redes sociales disponibles',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                              ],
                                                            )),
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
                            },
                          ),
                        if (services.length > 6)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: services.length - 6,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                            ),
                            itemBuilder: (context, index) {
                              final servicio = services[index + 6];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailServicePage(
                                          servicesData: servicio),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          child: Image.network(
                                            servicio.imageName ?? '',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: double.infinity,
                                                height: 120,
                                                color: Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey.shade600,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              utf8.decode(latin1.encode(
                                                  servicio.title ??
                                                      'Sin títutlo')),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 4),
                                            // Precio anterior
                                            if (servicio.price != null)
                                              Text(
                                                'Antes: S/${servicio.price!.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                            Row(
                                              children: [
                                                Text(
                                                  'S/${servicio.previousPrice!.toStringAsFixed(2) ?? 0}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    '-${(double.tryParse(servicio.descuento?.toString() ?? '0') ?? 0).toStringAsFixed(0)}%',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
        }
      },
    );
  }
}
