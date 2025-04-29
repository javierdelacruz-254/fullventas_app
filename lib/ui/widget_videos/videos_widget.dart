import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/videos_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/ui/widget_videos/videos_detalle.dart';

class VideosPubliWidget extends ConsumerWidget {
  const VideosPubliWidget({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PublicacionesDetailUseCase = ref.watch(videosDataProvider);
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";
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

        print("Publicaciones obtenidas: ${snapshot.data!.length}");

        List<PublicacionesData> publicaciones = snapshot.data!
            .where((pub) => pub.linkVideo != null && pub.linkVideo!.isNotEmpty)
            .toList();

        print("Publicaciones con videos: ${publicaciones.length}");

        Map<String, int> conteoPorCategoria = {};
        Map<String, String?> imagenPorCategoria = {};

        for (var pub in publicaciones) {
          String categoria = pub.categoria ?? 'Sin Categoria';
          conteoPorCategoria[categoria] =
              (conteoPorCategoria[categoria] ?? 0) + 1;
          print(
              "Publicación: ${pub.titulo} - Categoría: $categoria - Imagen: ${pub.image_name}");
          if (!imagenPorCategoria.containsKey(categoria)) {
            imagenPorCategoria[categoria] = pub.image_name;
          }
        }

        print("Conteo por categoría: $conteoPorCategoria");
        print("Imagen por categoría: $imagenPorCategoria");

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(10),
          itemCount: conteoPorCategoria.length,
          itemBuilder: (context, index) {
            String categoria = conteoPorCategoria.keys.elementAt(index);
            int cantidad = conteoPorCategoria[categoria]!;
            String? image = imagenPorCategoria[categoria];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideosDetalle(
                      categoria: categoria,
                      publicaciones: publicaciones
                          .where((pub) => pub.categoria == categoria)
                          .toList(),
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
                    colors: [hexToColor(colorHex), hexToColor(secondColor)],
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
                      child: image != null && image.isNotEmpty
                          ? Image.network(
                              image,
                              width:
                                  130, // Ajusta el tamaño según sea necesario
                              height: double.infinity,
                              fit: BoxFit
                                  .contain, // Hace que la imagen no se deforme
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error,
                                      color: Colors.red, size: 80),
                            )
                          : Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 80,
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
