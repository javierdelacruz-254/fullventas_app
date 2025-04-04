import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fullventas_app/domain/models/fullventas_data/repository/detalle_ejercicio.dart';

class DetalleEjercicio extends StatefulWidget {
  final int idEjercicio;

  const DetalleEjercicio({Key? key, required this.idEjercicio})
      : super(key: key);

  @override
  _DetalleEjercicioState createState() => _DetalleEjercicioState();
}

class _DetalleEjercicioState extends State<DetalleEjercicio> {
  Ejercicio? ejercicio;
  bool isLoading = true;
  bool hasError = false;
  List<String> imagenes = [];
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _fetchEjercicio();
  }

  Future<void> _fetchEjercicio() async {
    // Convertir idEjercicio a String
    String idEjercicioString = widget.idEjercicio.toString();

    final String url =
        "http://192.168.18.3/mystore/gull_ventas_php_project/get_detalle_ejercicios.php?id_ejercicio=$idEjercicioString";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          setState(() {
            // Convertir id_ejercicio a String dentro del JSON recibido
            data['data']['id_ejercicio'] =
                data['data']['id_ejercicio'].toString();

            ejercicio = Ejercicio.fromJson(data['data']);

            // Verifica imágenes antes de agregarlas
            imagenes = [
              if (ejercicio!.foto2 != null && ejercicio!.foto2!.isNotEmpty)
                ejercicio!.foto2!,
              if (ejercicio!.foto3 != null && ejercicio!.foto3!.isNotEmpty)
                ejercicio!.foto3!,
            ];

            // Inicializa el reproductor de YouTube solo si hay un video válido
            if (ejercicio!.video1 != null && ejercicio!.video1!.isNotEmpty) {
              final videoId = YoutubePlayer.convertUrlToId(ejercicio!.video1!);
              if (videoId != null) {
                _youtubeController = YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                );
              }
            }
            isLoading = false;
          });
        } else {
          _setErrorState();
        }
      } else {
        _setErrorState();
      }
    } catch (e) {
      print("Error en _fetchEjercicio: $e");
      _setErrorState();
    }
  }

  void _setErrorState() {
    setState(() {
      hasError = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading || ejercicio == null
            ? const Text("Cargando...")
            : Text(ejercicio!.nombreMusculo),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError || ejercicio == null
              ? const Center(child: Text("Error al cargar los datos"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '"${ejercicio!.idEjercicio}"', // Aquí se muestra el ID con comillas
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ejercicio!.descripcion,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            ...imagenes
                                .map((imageUrl) =>
                                    _buildImageWithPreview(imageUrl))
                                .toList(),
                            if (_youtubeController != null) _buildVideoPlayer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildImageWithPreview(String imageUrl) {
    return GestureDetector(
      onTap: () => _showFullScreenGallery(imageUrl),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Video del ejercicio",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
          ),
        ],
      ),
    );
  }

  void _showFullScreenGallery(String initialImage) {
    int initialIndex = imagenes.indexOf(initialImage);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: imagenes.length,
                pageController: PageController(initialPage: initialIndex),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imagenes[index]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: const BouncingScrollPhysics(),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
