enum MediaType { leg, dub, dual }

enum DownloadType { softsub, hardsub }

enum IdiomaType { none, ptBR, enUS, jaJP }

enum QualidadeDownload { pior, melhor }

enum ImageType { poster, wide, thumb }

enum StreamType { video, audio, legenda }

enum EpisodeType {
  leg(label: "Legendado", name: "LEG"),
  dub(label: "Dublado", name: "DUB");

  const EpisodeType({required this.label, required this.name});

  final String label;
  final String name;
}
