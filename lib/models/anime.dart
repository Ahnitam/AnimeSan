import 'package:animesan/models/temporada.dart';

class Anime {
  final String id;
  final String titulo;
  final String descricao;
  final String streamId;
  final String streamName;
  final String imageUrl;
  late final List<Temporada> temporadas;

  Anime({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.streamId,
    required this.streamName,
    required this.imageUrl,
    List<Temporada>? temporadas,
  }) {
    this.temporadas = temporadas ?? List.empty(growable: true);
  }

  Anime copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? streamId,
    String? imageUrl,
    List<Temporada>? temporadas,
    String? streamName,
  }) {
    return Anime(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      streamId: streamId ?? this.streamId,
      streamName: streamName ?? this.streamName,
      imageUrl: imageUrl ?? this.imageUrl,
      temporadas: temporadas ?? this.temporadas,
    );
  }

  @override
  String toString() {
    return "ID: $id - Titulo: $titulo - Descrição: $descricao}";
  }
}
