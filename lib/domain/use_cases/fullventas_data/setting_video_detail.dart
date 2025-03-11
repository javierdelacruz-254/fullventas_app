import 'package:fullventas_app/domain/dto/Video.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/setting_video_data_repo.dart';

class SettingVideoDetailUseCase {
  final SettingVideoDataRepo settingVideoDataRepo;
  SettingVideoDetailUseCase(this.settingVideoDataRepo);
  Future<List<Video>> getSettingVideoData() async {
    return await settingVideoDataRepo.getSettingVideoDataRepo();
  }
}
