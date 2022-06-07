import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';
import 'package:flutter/material.dart';

abstract class StreamModule {
  final String id;
  final String apiUrl;
  final Color color;
  final String icon;
  final String iconText;

  StreamModule({
    required this.id,
    required this.apiUrl,
    required this.icon,
    required this.iconText,
    required this.color,
  });

  Future<String> loginByUserSenha(String user, String senha);
  Future<String> loginBySession(String session);
  Future<void> refreshInfo(String session);
  Future<List<Anime>> buscar(String search);
  Future<Anime> getAnime(Anime anime);
  Future<void> download({required Episodio episodio, Episodio? episodioDub});
}
