import 'package:animesan/models/module.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/states.dart';
import 'package:animesan/utils/types.dart';
import 'package:get/get.dart';

class Anime {
  final String id;
  final String titulo;
  final String descricao;
  final Module module;
  final String imageUrl;
  final List<EpisodeType> temporadasEpisodeTypes = List.empty(growable: true);
  final List<Temporada> temporadas;
  final Rx<MidiaState> state = Rx<MidiaState>(MidiaState.inicial);

  Anime({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.module,
    required String? imageUrl,
    List<Temporada>? temporadas,
  })  : temporadas = temporadas ?? List.empty(growable: true),
        imageUrl = imageUrl ?? "";

  Anime copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? imageUrl,
    Module? module,
    List<Temporada>? temporadas,
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
