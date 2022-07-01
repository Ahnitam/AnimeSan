import 'package:animesan/models/anime.dart';

class MidiaController {
  MidiaController();

  Future<Anime> fetchAnime(Anime anime) async {
    if (anime.temporadas.isEmpty) {
      await anime.module.fetchAnimeInfo(anime);
    }
    return anime;
  }
}
