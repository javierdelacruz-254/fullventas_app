import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/publicaciones_data_provider.dart';
import 'package:fullventas_app/ui/detail_pages/detail_publicacion_page.dart';
import 'package:fullventas_app/ui/pages/publicaciones_page.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ListPublicaciones extends ConsumerWidget {
  const ListPublicaciones({super.key});

  String formatearFecha(DateTime fecha) {
    return DateFormat("EEEE d 'de' MMMM y", "en_US").format(fecha);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PublicacionesDetailUseCase = ref.watch(publicacionesDataProvider);
    final searchQuery = ref.watch(searchProvider);

    return FutureBuilder(
      future: PublicacionesDetailUseCase.getPublicacionesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemBuilder: (_, __) => _buildShimmer(),
            itemCount: 6,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          var publicaciones = snapshot.data!;

          if (searchQuery.isNotEmpty) {
            publicaciones = publicaciones
                .where((p) =>
                    p.titulo!.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
          }

          if (publicaciones.isEmpty) {
            return const Center(child: Text('No se encontró información'));
          }

          return publicaciones.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: publicaciones.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final publicacion = publicaciones[index];
                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPublicacionPage(
                                publicacionesData: publicacion,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImagen(publicacion),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    publicacion.titulo ?? 'Sin título',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    publicacion.categoria ?? 'Sin categoría',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.blueGrey),
                                  ),
                                  const SizedBox(height: 6),
                                  if (publicacion.fechaCreacion != null &&
                                      publicacion.fechaCreacion!.year > 1)
                                    Text(
                                      formatearFecha(
                                          publicacion.fechaCreacion!),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
        }
      },
    );
  }

  Widget _buildImagen(dynamic publicacion) {
    String? videoThumbnail;

    if ((publicacion.imagen == null || publicacion.imagen!.isEmpty) &&
        publicacion.link_video != null &&
        publicacion.link_video!.contains("youtube.com")) {
      // Extraer ID del video de YouTube
      final Uri uri = Uri.parse(publicacion.link_video!);
      final videoId = uri.queryParameters["v"];
      if (videoId != null) {
        videoThumbnail = "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
      }
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: publicacion.imagen != null && publicacion.imagen!.isNotEmpty
            ? Image.network(
                publicacion.imagen!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _errorImagen(),
              )
            : videoThumbnail != null
                ? Image.network(
                    videoThumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _errorImagen(),
                  )
                : _errorImagen(),
      ),
    );
  }

  Widget _errorImagen() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 20, width: 180, color: Colors.white),
                    SizedBox(height: 6),
                    Container(height: 16, width: 100, color: Colors.white),
                    SizedBox(height: 6),
                    Container(height: 14, width: 120, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
