import 'dart:convert';
import 'package:fullventas_app/config/routes/app_routes.dart';
import 'package:fullventas_app/domain/exceptions/failures.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/setting_video_data_repo.dart';
import 'package:fullventas_app/domain/models/fullventas_data/setting_video_data.dart';
import 'package:fullventas_app/infraestructure/helpers/http_helper_get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SettingVideoDataApi extends SettingVideoDataRepo {
  @override
  Future<List<SettingVideoData>> getSettingVideoDataRepo() async {
    final response = await HttpHelperGet.get(AppRoutes.getSettingVideo);
    if (response.statusCode == 200) {
      print("🔹 Respuesta API: ${response.body}");
      final settingVideoData = json.decode(response.body);

      List<SettingVideoData> videos = [];

      void addVideo(String? url, String? title) {
        if (url != null && url.isNotEmpty) {
          final videoId = YoutubePlayer.convertUrlToId(url);
          if (videoId != null) {
            videos.add(
                SettingVideoData(id: videoId, title: title ?? 'Sin título'));
          }
        }
      }

      addVideo(settingVideoData['url_video_one'],
          settingVideoData['titulo_video_one']);
      addVideo(settingVideoData['url_video_two'],
          settingVideoData['titulo_video_two']);
      addVideo(settingVideoData['url_video_three'],
          settingVideoData['titulo_video_three']);
      addVideo(settingVideoData['url_video_four'],
          settingVideoData['titulo_video_four']);
      addVideo(settingVideoData['url_video_five'],
          settingVideoData['titulo_video_five']);
      addVideo(settingVideoData['url_video_six'],
          settingVideoData['titulo_video_six']);
      addVideo(settingVideoData['url_video_seven'],
          settingVideoData['titulo_video_seven']);
      addVideo(settingVideoData['url_video_eight'],
          settingVideoData['titulo_video_eight']);

      print("📌 Videos convertidos: $videos");
      return videos;
    } else {
      throw SettingVideoDataApiError(
          'Error al obtener los datos. Código de estado: ${response.statusCode}');
    }
  }
}
