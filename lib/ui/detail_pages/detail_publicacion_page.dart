import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/publicaciones_data.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPublicacionPage extends ConsumerStatefulWidget {
  final PublicacionesData publicacionesData;

  const DetailPublicacionPage({super.key, required this.publicacionesData});

  @override
  DetailPublicacionPageState createState() => DetailPublicacionPageState();
}

class DetailPublicacionPageState extends ConsumerState<DetailPublicacionPage> {
  late YoutubePlayerController _controller;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = false;

    if (widget.publicacionesData.linkVideo != null &&
        widget.publicacionesData.linkVideo!.isNotEmpty) {
      String videoId =
          YoutubePlayer.convertUrlToId(widget.publicacionesData.linkVideo!) ??
              '';
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void dispose() {
    if (widget.publicacionesData.linkVideo != null &&
        widget.publicacionesData.linkVideo!.isNotEmpty) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool esVideo = widget.publicacionesData.tipoSeccion == 'video';
    Color hexToColor(String hex) {
      hex = hex.replaceAll("#", "");
      if (hex.length == 6) {
        hex = "FF$hex";
      }
      return Color(int.parse("0x$hex"));
    }

    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return Scaffold(
      backgroundColor: hexToColor(colorHex),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
        title: Text(''),
        backgroundColor: hexToColor(colorHex),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        color: hexToColor(colorHex),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 8.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: esVideo ? _buildVideoLayout() : _buildPublicacion(),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            utf8.decode(
                latin1.encode(widget.publicacionesData.titulo ?? 'Sin título')),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Me gusta ',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: toggleLike,
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Fecha de creación: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            if (widget.publicacionesData.fechaCreacion != null &&
                widget.publicacionesData.fechaCreacion!.year > 1)
              Text(
                '${DateFormat('EEEE', 'es_ES').format(widget.publicacionesData.fechaCreacion!)}, '
                '${widget.publicacionesData.fechaCreacion!.day} de '
                '${DateFormat('MMMM', 'es_ES').format(widget.publicacionesData.fechaCreacion!)} '
                'de ${widget.publicacionesData.fechaCreacion!.year}',
                style: TextStyle(fontSize: 15, color: Colors.black),
              )
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Categoria: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            Text(
              utf8.decode(latin1.encode(
                  widget.publicacionesData.categoria ?? 'Sin categoría')),
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Tipo de Seccion: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            Text(
              utf8.decode(latin1.encode(
                  widget.publicacionesData.tipoSeccion ?? 'Sin seccion')),
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          widget.publicacionesData.resumen!,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        SizedBox(height: 20),
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Video listo para reproducirse');
          },
        ),
      ],
    );
  }

  Widget _buildPublicacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          utf8.decode(
              latin1.encode(widget.publicacionesData.titulo ?? 'Sin título')),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Me gusta ',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: toggleLike,
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Fecha de creación: ${widget.publicacionesData.fechaCreacion ?? 'Sin fecha'}',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Categoria: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            Text(
              utf8.decode(latin1.encode(
                  widget.publicacionesData.categoria ?? 'Sin categoría')),
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Tipo de Seccion: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            Text(
              utf8.decode(latin1.encode(
                  widget.publicacionesData.tipoSeccion ?? 'Sin seccion')),
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            widget.publicacionesData.imagen ?? '',
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey.shade600,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Html(
          data: widget.publicacionesData.subtitulo1 ?? 'Sin subtitulo',
        ),
        Html(
          data: widget.publicacionesData.descripcion1 ?? 'Sin descripción',
        ),
        SizedBox(height: 20),
        if (widget.publicacionesData.adjunto11Imagen != null &&
            widget.publicacionesData.adjunto11Imagen!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.publicacionesData.adjunto11Imagen!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),
        if (widget.publicacionesData.adjunto11Video != null &&
            widget.publicacionesData.adjunto11Video!.isNotEmpty)
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(
                      widget.publicacionesData.adjunto11Video!) ??
                  '',
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            ),
            showVideoProgressIndicator: true,
          ),
      ],
    );
  }
}
