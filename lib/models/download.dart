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

  final DownloadStream hardsub;
  final DownloadStream softsub;

  Download({
    required this.episodeId,
    required this.seasonId,
    required this.animeName,
    required this.seasonEpisode,
    required this.duration,
    required this.tipo,
    required this.stream,
    DownloadStream? hardsub,
    DownloadStream? softsub,
    this.status = "Esperando na fila de Downloads",
  })  : hardsub = hardsub ?? DownloadStream(),
        softsub = softsub ?? DownloadStream();
}

class DownloadStream {
  final DownloadStreamOptions video;
  final DownloadStreamOptions audio;
  final DownloadStreamOptions legenda;

  DownloadStream({
    DownloadStreamOptions? video,
    DownloadStreamOptions? audio,
    DownloadStreamOptions? legenda,
  })  : video = video ?? DownloadStreamOptions(),
        audio = audio ?? DownloadStreamOptions(),
        legenda = legenda ?? DownloadStreamOptions();
}

class DownloadStreamOptions {
  final DownloadStreamOptionInfo dub;
  final DownloadStreamOptionInfo leg;
  DownloadStreamOptions({
    DownloadStreamOptionInfo? dub,
    DownloadStreamOptionInfo? leg,
  })  : dub = dub ?? DownloadStreamOptionInfo(),
        leg = leg ?? DownloadStreamOptionInfo();
}

class DownloadStreamOptionInfo {
  String? url;
  String? type;

  DownloadStreamOptionInfo({
    this.url,
    this.type,
  });
}
