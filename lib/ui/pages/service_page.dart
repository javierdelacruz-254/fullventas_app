import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/anuncios_data_provider.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/services_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';
import 'package:fullventas_app/ui/pages/carrito_page.dart';
import 'package:fullventas_app/ui/widgets_service/carrusel_service.dart';
import 'package:fullventas_app/ui/widgets_service/list_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicePage extends ConsumerWidget {
  const ServicePage({super.key});

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
    final searchQuery = ref.watch(searchQueryProvider);

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
                      final totalCantidad = ref.watch(carritoProvider).fold(
                          0, (sum, item) => sum + item['cantidad'] as int);

                      return totalCantidad > 0
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 8,
                              child: Text(
                                totalCantidad
                                    .toString(), // Ahora muestra la cantidad real
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
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
                color: hexToColor(colorHex),
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
                color: hexToColor(secondColor),
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
              Consumer(
                builder: (context, ref, _) {
                  final anuncioProvider = ref.watch(anunciosDataProvider);

                  return FutureBuilder<List<AnunciosData>>(
                      future: anuncioProvider.getAnunciosBySeccion('Listado 1'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No hay anuncios disponibles.');
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
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  anuncio.url_imagen!),
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
                                              final redes =
                                                  anuncio.url_redes ?? [];

                                              if (redes.length == 1) {
                                                executeUrl(redes.first);
                                              } else if (redes.length > 1) {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: false,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  builder: (context) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Elige una red para visitar',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          GridView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                redes.length,
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 4,
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
                                                                  obtenerIconoRedSocial(
                                                                      red);
                                                              final nombreRed =
                                                                  obtenerNombreRedSocial(
                                                                      red);
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  executeUrl(
                                                                      red);
                                                                },
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          26,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black12,
                                                                      child:
                                                                          FaIcon(
                                                                        icono,
                                                                        size:
                                                                            28,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            6),
                                                                    Text(
                                                                      nombreRed,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              hexToColor(colorTextoSecond)),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                                color: Colors.black.withOpacity(
                                                    0.5), // Transparencia
                                                width: double
                                                    .infinity, // Para que ocupe todo el ancho
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Siguenos en:',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                              obtenerIconoRedSocial(
                                                                  anuncio
                                                                      .url_redes!
                                                                      .first),
                                                              color:
                                                                  Colors.white,
                                                              size: 18,
                                                            ),
                                                            if (anuncio
                                                                    .url_redes!
                                                                    .length >
                                                                1) ...[
                                                              SizedBox(
                                                                  width: 8.0),
                                                              Text(
                                                                'ver más',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ]
                                                          ])
                                                    else
                                                      Text(
                                                        'Sin redes sociales disponibles',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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

              //-------------------
              //LISTADO DE SERVICIOS
              //-------------------
              ListService(),
              Consumer(
                builder: (context, ref, _) {
                  final anuncioProvider = ref.watch(anunciosDataProvider);

                  return FutureBuilder<List<AnunciosData>>(
                      future: anuncioProvider.getAnunciosBySeccion('Listado 3'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No hay anuncios disponibles.');
                        }

                        final anuncios = snapshot.data!;

                        if (anuncios.length == 1) {
                          final anuncio = anuncios.first;
                          return SizedBox(
                            width: 339,
                            height: 200,
                            child: Image.network(
                              anuncio.url_imagen!,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return CarouselSlider(
                            options: CarouselOptions(
                                height: 200.0,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.9),
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
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  anuncio.url_imagen!),
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
                                              final redes =
                                                  anuncio.url_redes ?? [];

                                              if (redes.length == 1) {
                                                executeUrl(redes.first);
                                              } else if (redes.length > 1) {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: false,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  builder: (context) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Elige una red para visitar',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          GridView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                redes.length,
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 4,
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
                                                                  obtenerIconoRedSocial(
                                                                      red);
                                                              final nombreRed =
                                                                  obtenerNombreRedSocial(
                                                                      red);
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  executeUrl(
                                                                      red);
                                                                },
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          26,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black12,
                                                                      child:
                                                                          FaIcon(
                                                                        icono,
                                                                        size:
                                                                            28,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            6),
                                                                    Text(
                                                                      nombreRed,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              hexToColor(colorTextoSecond)),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                                color: Colors.black.withOpacity(
                                                    0.5), // Transparencia
                                                width: double
                                                    .infinity, // Para que ocupe todo el ancho
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Siguenos en:',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                              obtenerIconoRedSocial(
                                                                  anuncio
                                                                      .url_redes!
                                                                      .first),
                                                              color:
                                                                  Colors.white,
                                                              size: 18,
                                                            ),
                                                            if (anuncio
                                                                    .url_redes!
                                                                    .length >
                                                                1) ...[
                                                              SizedBox(
                                                                  width: 8.0),
                                                              Text(
                                                                'ver más',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ]
                                                          ])
                                                    else
                                                      Text(
                                                        'Sin redes sociales disponibles',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
            ],
          ),
        ));
  }
}
