import 'package:animesan/models/anime.dart';
import 'package:animesan/models/stream_module.dart';

class HomeController {
  List<Anime> animes = List.empty();

  Future<List<Anime>> searchAnime(StreamModule stream, String text) async {
    animes = await stream.buscar(text);
    return animes;
  }
}
