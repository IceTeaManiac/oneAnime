import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/request/danmaku.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {
  @observable
  List<String> token = [];

  List<String> danmakuToken = [];

  @observable
  int episode = 1;

  String videoUrl = '';
  String videoCookie = '';
  String title = '';
  String from = '/tab/popular/';

  Future changeEpisode(int episode) async {
    final PlayerController playerController = Modular.get<PlayerController>();
    final PopularController popularController = Modular.get<PopularController>();
    popularController.updateAnimeProgress(episode, title);
    var result = await VideoRequest.getVideoLink(token[token.length - episode]); 
    videoUrl = result['link'];
    videoCookie = result['cookie']; 
    playerController.videoUrl = videoUrl;
    playerController.videoCookie = videoCookie; 
    this.episode = episode;
    await playerController.init();
  }

  Future getDanmakuList(String title) async {
    danmakuToken = await DanmakuRequest.getAniDanmakuList(title);
  }
}
