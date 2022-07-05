import 'package:animesan/models/anime.dart';
import 'package:animesan/utils/states.dart';

class MidiaController {
  MidiaController();

  Future<void> fetchAnime(Anime anime) async {
    try {
      if (anime.temporadas.isEmpty) {
        anime.state.value = AnimeState.carregando;
        await anime.module.fetchAnimeInfo(anime);
      }
      anime.state.value = AnimeState.carregado;
    } catch (e) {
      anime.state.value = AnimeState.error;
    }
  }
}
