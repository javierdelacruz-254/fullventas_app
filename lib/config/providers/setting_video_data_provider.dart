import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/dto/Video.dart';
import 'package:fullventas_app/domain/models/fullventas_data/repository/setting_video_data_repo.dart';
import 'package:fullventas_app/domain/use_cases/fullventas_data/setting_video_detail.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/setting_video_data_api.dart';

final settingVideoRepoProvider = Provider<SettingVideoDataRepo>((ref) {
  return SettingVideoDataApi();
});

final settingVideoUseCaseProvider = Provider<SettingVideoDetailUseCase>((ref) {
  final repo = ref.watch(settingVideoRepoProvider);
  return SettingVideoDetailUseCase(repo);
});

final settingVideoDataProvider = FutureProvider<List<Video>>(
  (ref) async {
    final useCase = ref.watch(settingVideoUseCaseProvider);
    return await useCase.getSettingVideoData();
  },
);
