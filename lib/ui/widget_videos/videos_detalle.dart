import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/ui/widget_videos/video_most_detail.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosDetalle extends ConsumerWidget {
  final String categoria;
  final List<PublicacionesData> publicaciones;

  const VideosDetalle(
      {super.key, required this.categoria, required this.publicaciones});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PublicacionesData> videosDeCategoria =
        publicaciones.where((pub) => pub.categoria == categoria).toList();
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return Scaffold(
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
      ),
      backgroundColor: hexToColor(colorHex),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                categoria,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: videosDeCategoria.length,
              itemBuilder: (context, index) {
                final video = videosDeCategoria[index];

                String? videoId =
                    YoutubePlayer.convertUrlToId(video.linkVideo ?? "");

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoMostDetail(
                              videoSeleccionado: video,
                              videosDeCategoria: videosDeCategoria)),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: hexToColor(secondColor),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.titulo ?? 'Video sin título',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: YoutubePlayerBuilder(
                                  player: YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId: videoId!,
                                      flags: const YoutubePlayerFlags(
                                        autoPlay: false,
                                        mute: true,
                                        showLiveFullscreenButton: false,
                                      ),
                                    ),
                                    showVideoProgressIndicator: false,
                                  ),
                                  builder: (context, player) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: player,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: hexToColor(colorHex),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${DateFormat('EEEE', 'es_ES').format(video.fechaCreacion!)}, '
                              '${video.fechaCreacion!.day} de'
                              '${DateFormat('MMMM', 'es_ES').format(video.fechaCreacion!)}'
                              'de ${video.fechaCreacion!.year}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
