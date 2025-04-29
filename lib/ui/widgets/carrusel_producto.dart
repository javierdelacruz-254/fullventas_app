import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/anuncios_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductCarousel extends ConsumerWidget {
  final String seccion;
  const ProductCarousel({super.key, required this.seccion});

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

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  bool esVideoYoutube(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool pantallaCompleta = false;
    CarouselController _controller = CarouselController();

    final sliderDetailUseCase = ref.watch(anunciosDataProvider);
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

    return FutureBuilder<List<AnunciosData>>(
      future: sliderDetailUseCase.getAnunciosBySeccion(seccion),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final anuncios = snapshot.data!;

          return anuncios.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          height: 280.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          enlargeCenterPage: true,
                          viewportFraction: 0.95),
                      items: anuncios.map((anuncio) {
                        return Builder(
                          builder: (BuildContext context) {
                            final isYoutubeVideo =
                                esVideoYoutube(anuncio.url_imagen!);

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Para redondear las esquinas
                              child: Stack(
                                fit: StackFit
                                    .expand, // Asegura que la imagen y el cuadro ocupen
                                children: [
                                  isYoutubeVideo
                                      ? YoutubePlayer(
                                          controller: YoutubePlayerController(
                                            initialVideoId:
                                                YoutubePlayer.convertUrlToId(
                                                    anuncio.url_imagen!)!,
                                            flags: const YoutubePlayerFlags(
                                              autoPlay: true,
                                              mute: true,
                                              controlsVisibleAtStart: false,
                                              hideControls: true,
                                              loop: true,
                                            ),
                                          ),
                                          showVideoProgressIndicator: false,
                                        )
                                      // Imagen principal
                                      : Container(
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
                                        final redes = anuncio.url_redes ?? [];

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
                                                      top: Radius.circular(20)),
                                            ),
                                            builder: (context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Elige una red para visitar',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: hexToColor(
                                                              colorTextoSecond)),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GridView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: redes.length,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 4,
                                                        mainAxisSpacing: 20,
                                                        crossAxisSpacing: 20,
                                                        childAspectRatio: 0.8,
                                                      ),
                                                      itemBuilder:
                                                          (context, index) {
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
                                                            executeUrl(red);
                                                          },
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 26,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black12,
                                                                child: FaIcon(
                                                                  icono,
                                                                  size: 28,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 6),
                                                              Text(
                                                                nombreRed,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: hexToColor(
                                                                        colorTextoSecond)),
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
                                              vertical: 10.0, horizontal: 20.0),
                                          color: Colors.black.withOpacity(
                                              0.5), // Transparencia
                                          width: double
                                              .infinity, // Para que ocupe todo el ancho
                                          child: Column(
                                            children: [
                                              Text(
                                                'Siguenos en:',
                                                style: TextStyle(
                                                  color: hexToColor(colorTexto),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              if ((anuncio.url_redes ?? [])
                                                  .isNotEmpty)
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FaIcon(
                                                        obtenerIconoRedSocial(
                                                            anuncio.url_redes!
                                                                .first),
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      if (anuncio.url_redes!
                                                              .length >
                                                          1) ...[
                                                        SizedBox(width: 8.0),
                                                        Text(
                                                          'ver más',
                                                          style: TextStyle(
                                                            color: hexToColor(
                                                                colorTexto),
                                                            fontSize: 14.0,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]
                                                    ])
                                              else
                                                Text(
                                                  'Sin redes sociales disponibles',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                    ),
                  ],
                );
        }
      },
    );
  }
}
