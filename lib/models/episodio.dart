import 'package:animesan/models/download.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/states.dart';
import 'package:animesan/utils/types.dart';
import 'package:get/get.dart';

class Episodio {
  final String id;
  final String titulo;
  final String descricao;
  final bool isPremium;
  final Duration duracao;
  final String numero;
  final Temporada temporada;
  final Map<EpisodeType, String> mediasId;
  Download? download;
  final Rx<MidiaState> state = Rx<MidiaState>(MidiaState.inicial);
  final String imageUrl;

  Episodio({
    required this.id,
    required this.mediasId,
    required this.duracao,
    required this.isPremium,
    required this.titulo,
    required this.descricao,
    required this.temporada,
    required this.numero,
    required String? imageUrl,
    this.download,
  }) : imageUrl = imageUrl ?? "";
}
