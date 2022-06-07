import 'package:animesan/models/temporada.dart';

class Anime {
  final String id;
  final String titulo;
  final String descricao;
  final String streamId;
  String? imageUrl;
  late final List<Temporada> temporadas;

  Anime({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.streamId,
    this.imageUrl,
    List<Temporada>? temporadas,
  }) {
    this.temporadas = temporadas ?? List.empty(growable: true);
  }

  Anime copyWith({String? id, String? titulo, String? descricao, String? streamId, String? imageUrl, List<Temporada>? temporadas}) {
    return Anime(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      streamId: streamId ?? this.streamId,
      imageUrl: imageUrl ?? this.imageUrl,
      temporadas: temporadas ?? this.temporadas,
    );
  }

  @override
  String toString() {
    return "ID: $id - Titulo: $titulo - Descrição: $descricao}";
  }
}
