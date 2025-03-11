import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/videos_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/ui/widget_videos/videos_detalle.dart';

class VideosPubliWidget extends ConsumerWidget {
  const VideosPubliWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PublicacionesDetailUseCase = ref.watch(videosDataProvider);

    return FutureBuilder<List<PublicacionesData>>(
      future: PublicacionesDetailUseCase.getPublicacionesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error al cargar los datos"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No hay videos disponibles"));
        }

        List<PublicacionesData> publicaciones = snapshot.data!
            .where((pub) => pub.linkVideo != null && pub.linkVideo!.isNotEmpty)
            .toList();

        Map<String, int> conteoPorCategoria = {};
        for (var pub in publicaciones) {
          String categoria = pub.categoria ?? 'Sin Categoria';
          conteoPorCategoria[categoria] =
              (conteoPorCategoria[categoria] ?? 0) + 1;
        }

        Map<String, String> imagenesPorCategoria = {
          'Spinning':
              'https://www.thebronx.mx/wp-content/uploads/2021/01/Spinning-1024x1024.png',
          'Step':
              'https://freemotionfitness.com/wp-content/uploads/2020/07/G614-Profile-F.png',
          'Sin Categoria': '',
        };

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(10),
          itemCount: conteoPorCategoria.length,
          itemBuilder: (context, index) {
            String categoria = conteoPorCategoria.keys.elementAt(index);
            int cantidad = conteoPorCategoria[categoria]!;
            String imageUrl = imagenesPorCategoria[categoria] ??
                imagenesPorCategoria['Sin Categoria']!;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideosDetalle(
                      categoria: categoria,
                      publicaciones: publicaciones,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(16),
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 11, 82, 163),
                      Color(0xFF3391FA)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            categoria,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Videos: $cantidad",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        imageUrl,
                        width: 130, // Ajusta el tamaño según sea necesario
                        height: double.infinity,
                        fit: BoxFit.contain, // Hace que la imagen no se deforme
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, color: Colors.red, size: 80),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
