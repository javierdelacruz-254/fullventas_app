import 'package:fullventas_app/domain/dto/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SettingVideoData extends Video {
  SettingVideoData({required super.id, required super.title});

  factory SettingVideoData.fromJson(Map<String, dynamic> json) {
    final videoId = json['url_video'] != null
        ? YoutubePlayer.convertUrlToId(json['url_video'])
        : null;

    return SettingVideoData(
        id: videoId ?? '', title: json['titulo_video'] ?? 'Sin titulo');
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }
}
