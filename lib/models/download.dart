import 'package:animesan/utils/types.dart';

class Download {
  final String episodeId;
  final String seasonId;
  final String animeName;
  final String seasonEpisode;
  final Duration duration;
  final String status;
  final MediaType tipo;
  final String stream;
  final Map<String, Map<String, Map<String, String>>> streams;

  Download({
    required this.episodeId,
    required this.seasonId,
    required this.animeName,
    required this.seasonEpisode,
    required this.duration,
    required this.tipo,
    required this.stream,
    required this.streams,
    this.status = "Esperando na fila de Downloads",
  });
}
