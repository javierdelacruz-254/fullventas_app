import 'package:flutter/material.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/ui/widget_videos/video_most_detail.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosDetalle extends StatelessWidget {
  final String categoria;
  final List<PublicacionesData> publicaciones;

  const VideosDetalle(
      {super.key, required this.categoria, required this.publicaciones});

  @override
  Widget build(BuildContext context) {
    List<PublicacionesData> videosDeCategoria =
        publicaciones.where((pub) => pub.categoria == categoria).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.blue,
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
                    color: Colors.blue.shade200,
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
                              color: Colors.blue.shade600,
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
