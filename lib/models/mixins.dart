import 'package:animesan/models/download.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/types.dart';
import 'package:flutter/material.dart';

mixin TabConfig {
  String get tabTitle;
  IconData get tabIcon;
}

mixin InfoModule on Module {
  Future<void> setEpisodeInfo(Episodio episodio);
}

mixin StreamModule on Module {
  Future<Download> fetchDownloadInfo({
    required Episodio episodio,
    MediaType? mediaType,
    IdiomaType idiomaType,
    QualidadeDownload qualidade,
  });
}
