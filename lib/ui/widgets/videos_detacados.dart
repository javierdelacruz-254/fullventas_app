import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/setting_video_data_provider.dart';
import 'package:fullventas_app/domain/dto/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoWidget extends ConsumerWidget {
  const VideoWidget({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsyncValue = ref.watch(settingVideoDataProvider);
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

    return videoAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (videos) {
        if (videos.isEmpty) {
          return const Center(child: Text('No hay videos disponibles'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return FeaturedVideo(video: video);
          },
        );
      },
    );
  }
}

class FeaturedVideo extends ConsumerWidget {
  final Video video;

  const FeaturedVideo({super.key, required this.video});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: video.id,
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: hexToColor(colorHex),
                progressColors: ProgressBarColors(
                  playedColor: hexToColor(colorHex),
                  handleColor: hexToColor(colorHex),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            video.title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: hexToColor(colorTextoSecond),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
