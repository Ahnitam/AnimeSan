import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';

class Temporada {
  final String id;
  final String titulo;
  final String numero;
  late final List<Episodio> episodios;

  final Anime anime;

  Temporada({
    required this.id,
    required this.titulo,
    required this.anime,
    required this.numero,
    List<Episodio>? episodios,
  }) {
    this.episodios = episodios ?? List.empty(growable: true);
  }
}
