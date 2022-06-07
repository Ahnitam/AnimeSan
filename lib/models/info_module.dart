import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';
import 'package:flutter/material.dart';

abstract class InfoModule {
  final String id;
  final String apiUrl;
  final Color color;
  final String pathLogo;
  final String pathLogoTexto;

  InfoModule({
    required this.id,
    required this.apiUrl,
    required this.color,
    required this.pathLogo,
    required this.pathLogoTexto,
  });

  Future<void> login(String user, String senha);
  Future<void> refreshInfo(String session);
  Future<List<Anime>> buscar(String s);
  Future<void> getAnime(Anime anime);
  Future<bool> setEpisodeInfo(Episodio episodio);
}
