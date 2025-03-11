import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductVideoWidget extends StatefulWidget {
  final String? videoLinkOne;
  final String? videoLinkTwo;

  const ProductVideoWidget({
    super.key,
    required this.videoLinkOne,
    required this.videoLinkTwo,
  });

  @override
  _ProductVideoWidgetState createState() => _ProductVideoWidgetState();
}

class _ProductVideoWidgetState extends State<ProductVideoWidget> {
  YoutubePlayerController? _controller;
  String? _selectedVideo;

  @override
  void initState() {
    super.initState();
    _selectedVideo = widget.videoLinkOne ??
        widget.videoLinkTwo; // Seleccionar el primer video disponible

    if (_selectedVideo != null) {
      _initializeVideo(_selectedVideo!);
    }
  }

  void _initializeVideo(String url) {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  void _changeVideo(String url) {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null && _controller != null) {
      _controller!.load(videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return SizedBox.shrink();
    }

    bool hasVideoOne = widget.videoLinkOne != null;
    bool hasVideoTwo = widget.videoLinkTwo != null;
    bool hasBothVideos = hasVideoOne && hasVideoTwo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasBothVideos) ...[
          Text(
            "Video del Producto:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _changeVideo(widget.videoLinkOne!),
                child: Text("Video 1"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _changeVideo(widget.videoLinkTwo!),
                child: Text("Video 2"),
              ),
            ],
          ),
        ],
        SizedBox(
            height: hasBothVideos ? 10 : 0), // Espaciado solo si hay 2 videos
        YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
        ),
      ],
    );
  }
}
