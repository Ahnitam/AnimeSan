import 'package:animesan/models/anime.dart';

class CachedAnimes {
  final List<Anime> _animes = List.empty(growable: true);

  Anime getAnimeCached({required Anime animeSearched}) {
    try {
      return _animes.firstWhere((animeCached) => animeCached.id == animeSearched.id && animeCached.module == animeSearched.module);
    } catch (e) {
      _animes.add(animeSearched);
      return animeSearched;
    }
  }
}
