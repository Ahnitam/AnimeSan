import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/states.dart';

class MidiaController {
  MidiaController();

  Future<void> fetchAnime(Anime anime) async {
    try {
      if (anime.temporadas.isEmpty) {
        anime.state.value = MidiaState.carregando;
        await anime.module.fetchAnimeInfo(anime);
      }
      anime.state.value = MidiaState.carregado;
    } catch (e) {
      anime.state.value = MidiaState.error;
    }
  }

  Future<void> fetchDownload(Episodio episodio) async {
    try {
      if (episodio.download == null) {
        episodio.state.value = MidiaState.carregando;
        episodio.download = await (episodio.temporada.anime.module as StreamModule).fetchDownloadInfo(episodio: episodio);
      }
      episodio.state.value = MidiaState.carregado;
    } catch (e) {
      episodio.state.value = MidiaState.error;
    }
  }
}
