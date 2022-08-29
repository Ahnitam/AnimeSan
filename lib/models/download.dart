import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'episodeId': episodeId});
    result.addAll({'seasonId': seasonId});
    result.addAll({'animeName': animeName});
    result.addAll({'seasonEpisode': seasonEpisode});
    result.addAll({'duration': duration.inMilliseconds});
    result.addAll({'status': status});
    result.addAll({'tipo': tipo.name});
    result.addAll({'stream': stream});
    result.addAll({'hardsub': hardsub.toMap()});
    result.addAll({'softsub': softsub.toMap()});

    return result;
  }

  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
      episodeId: map['episodeId'] ?? '',
      seasonId: map['seasonId'] ?? '',
      animeName: map['animeName'] ?? '',
      seasonEpisode: map['seasonEpisode'] ?? '',
      duration: Duration(milliseconds: map['duration']),
      status: map['status'] ?? '',
      tipo: MediaType.values.firstWhere((element) => element.name == map['tipo'], orElse: () => MediaType.leg),
      stream: map['stream'] ?? '',
      hardsub: DownloadStream.fromMap(map['hardsub']),
      softsub: DownloadStream.fromMap(map['softsub']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Download.fromJson(String source) => Download.fromMap(json.decode(source));
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

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'video': video.toMap()});
    result.addAll({'audio': audio.toMap()});
    result.addAll({'legenda': legenda.toMap()});

    return result;
  }

  factory DownloadStream.fromMap(Map<String, dynamic> map) {
    return DownloadStream(
      video: DownloadStreamOptions.fromMap(map['video']),
      audio: DownloadStreamOptions.fromMap(map['audio']),
      legenda: DownloadStreamOptions.fromMap(map['legenda']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadStream.fromJson(String source) => DownloadStream.fromMap(json.decode(source));
}

class DownloadStreamOptions {
  final DownloadStreamOptionInfo dub;
  final DownloadStreamOptionInfo leg;
  DownloadStreamOptions({
    DownloadStreamOptionInfo? dub,
    DownloadStreamOptionInfo? leg,
  })  : dub = dub ?? DownloadStreamOptionInfo(),
        leg = leg ?? DownloadStreamOptionInfo();

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'dub': dub.toMap()});
    result.addAll({'leg': leg.toMap()});

    return result;
  }

  factory DownloadStreamOptions.fromMap(Map<String, dynamic> map) {
    return DownloadStreamOptions(
      dub: DownloadStreamOptionInfo.fromMap(map['dub']),
      leg: DownloadStreamOptionInfo.fromMap(map['leg']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadStreamOptions.fromJson(String source) => DownloadStreamOptions.fromMap(json.decode(source));
}

class DownloadStreamOptionInfo {
  String? url;
  String? type;

  DownloadStreamOptionInfo({
    this.url,
    this.type,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'url': url});
    result.addAll({'type': type});
    return result;
  }

  factory DownloadStreamOptionInfo.fromMap(Map<String, dynamic> map) {
    return DownloadStreamOptionInfo(
      url: map['url'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadStreamOptionInfo.fromJson(String source) => DownloadStreamOptionInfo.fromMap(json.decode(source));
}
