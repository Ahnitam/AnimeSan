import 'package:animesan/models/download.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/types.dart';

class Episodio {
  final String id;
  final String titulo;
  final String descricao;
  final bool isPremium;
  final Duration duracao;
  final String numero;
  final Temporada temporada;
  final Map<MediaType, String> mediasId;
  Download? download;
  String imageUrl;

  Episodio({
    required this.id,
    required this.mediasId,
    required this.duracao,
    required this.isPremium,
    required this.titulo,
    required this.descricao,
    required this.temporada,
    required this.numero,
    required this.imageUrl,
    this.download,
  });
}
