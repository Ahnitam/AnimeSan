import 'package:animesan/models/module.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/states.dart';
import 'package:get/get.dart';

class Anime {
  final String id;
  final String titulo;
  final String descricao;
  final Module module;
  final String imageUrl;
  final List<Temporada> temporadas;
  final Rx<AnimeState> state = Rx<AnimeState>(AnimeState.inicial);

  Anime({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.module,
    required this.imageUrl,
    List<Temporada>? temporadas,
  }) : temporadas = temporadas ?? List.empty(growable: true);

  Anime copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? streamId,
    String? imageUrl,
    Module? module,
    List<Temporada>? temporadas,
    String? streamName,
  }) {
    return Anime(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      module: module ?? this.module,
      imageUrl: imageUrl ?? this.imageUrl,
      temporadas: temporadas ?? this.temporadas,
    );
  }

  @override
  String toString() {
    return "ID: $id - Titulo: $titulo - Descrição: $descricao}";
  }
}
