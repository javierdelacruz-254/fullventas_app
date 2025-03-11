import 'package:fullventas_app/domain/models/fullventas_data/setting_video_data.dart';

abstract class SettingVideoDataRepo {
  Future<List<SettingVideoData>> getSettingVideoDataRepo();
}
