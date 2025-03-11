import 'package:flutter/material.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoMostDetail extends StatefulWidget {
  final PublicacionesData videoSeleccionado;
  final List<PublicacionesData> videosDeCategoria;

  const VideoMostDetail(
      {super.key,
      required this.videoSeleccionado,
      required this.videosDeCategoria});

  @override
  VideoMostDetailState createState() => VideoMostDetailState();
}

class VideoMostDetailState extends State<VideoMostDetail> {
  late YoutubePlayerController _controller;
  late PublicacionesData _videoActual;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoActual = widget.videoSeleccionado;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(_videoActual.linkVideo!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _seleccionarVideo(PublicacionesData video) {
    if (video.linkVideo == _videoActual.linkVideo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este video ya está en reproducción'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _videoActual = video;
      _controller.load(YoutubePlayer.convertUrlToId(video.linkVideo!)!);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            icon: Icon(Icons.home),
          )
        ],
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          const SizedBox(height: 10),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Me gusta',
                    style: TextStyle(fontSize: 15),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : Colors.redAccent,
                      size: 30,
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Resumen del video: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(_videoActual.resumen!),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: widget.videosDeCategoria.length,
              itemBuilder: (context, index) {
                final video = widget.videosDeCategoria[index];
                final bool isSelected =
                    video.linkVideo == _videoActual.linkVideo;

                return GestureDetector(
                  onTap: () => _seleccionarVideo(video),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: isSelected ? Colors.red : Colors.blue,
                    elevation: isSelected ? 4 : 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Ícono de Play centrado
                          const Icon(Icons.play_circle_fill,
                              color: Colors.blue, size: 40),
                          const SizedBox(height: 5),

                          // Título del video
                          Text(
                            video.titulo ?? 'Sin título',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 5),

                          // Fecha del video
                          Text(
                            video.fechaCreacion!.toIso8601String(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
