import 'package:animesan/components/cards/episodio_card.dart';
import 'package:animesan/components/delegates/choose_temporada.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/states.dart';
import 'package:animesan/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimeInfo extends StatefulWidget {
  final Anime anime;
  final Rx<EpisodeType?> _selectedTemporadaType;
  final Function(Episodio)? onClickEpisode;
  final Widget? appBar;
  final bool showAllTemporadas;

  final bool backgroundAnimeImage;

  AnimeInfo({
    Key? key,
    required this.anime,
    Rx<EpisodeType?>? selectedTemporadaType,
    this.showAllTemporadas = false,
    this.backgroundAnimeImage = true,
    this.onClickEpisode,
    this.appBar,
  })  : _selectedTemporadaType = selectedTemporadaType ?? Rx(null),
        super(key: key);

  @override
  State<AnimeInfo> createState() => _AnimeInfoState();
}

class _AnimeInfoState extends State<AnimeInfo> {
  final Rx<Temporada?> _selectedTemporada = Rx<Temporada?>(null);

  final MidiaController _midiaController = Get.find<MidiaController>();

  @override
  void initState() {
    super.initState();
    if (widget.anime.state.value == MidiaState.inicial) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _midiaController.fetchAnime(widget.anime);
        if (widget._selectedTemporadaType.value == null && widget.anime.temporadasEpisodeTypes.isNotEmpty && !widget.showAllTemporadas) {
          widget._selectedTemporadaType.value = widget.anime.temporadasEpisodeTypes.first;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (widget.anime.state.value == MidiaState.error) {
          return const Center(
            child: Text("Error"),
          );
        } else if (widget.anime.state.value == MidiaState.carregado) {
          if (widget.anime.temporadas.isEmpty) {
            return const Center(
              child: Text("Sem Temporadas"),
            );
          } else {
            final List<Temporada> temporadas = widget.anime.temporadas
                .where((temp) => widget._selectedTemporadaType.value == null ? true : temp.tipo == widget._selectedTemporadaType.value)
                .toList(growable: false);
            _selectedTemporada.value = temporadas.first;
            return Container(
              decoration: BoxDecoration(
                image: widget.backgroundAnimeImage
                    ? DecorationImage(
                        image: NetworkImage(widget.anime.imageUrl),
                        onError: (_, __) {
                          debugPrint("Erro ao carregar imagem");
                        },
                        fit: BoxFit.cover,
                        opacity: 0.3,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                      )
                    : null,
              ),
              height: double.infinity,
              width: double.infinity,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[]
                  ..addIf(widget.appBar != null, widget.appBar ?? const SliverAppBar())
                  ..addAll(
                    [
                      SliverPersistentHeader(
                        delegate: ChooseTemporada(
                          temporadas: temporadas,
                          selectedTemporada: _selectedTemporada,
                        ),
                        pinned: true,
                        // floating: true,
                      ),
                      Obx(() {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) {
                              return EpisodioCard(
                                episodio: _selectedTemporada.value!.episodios[index],
                                height: 150,
                                margin: EdgeInsets.only(
                                  top: index == 0 ? 0 : 10,
                                  left: 10,
                                  right: 10,
                                  bottom: index == _selectedTemporada.value!.episodios.length - 1 ? 10 : 0,
                                ),
                                onClick: widget.onClickEpisode,
                              );
                            },
                            childCount: _selectedTemporada.value!.episodios.length,
                          ),
                        );
                      }),
                    ],
                  ),
              ),
            );
          }
        } else {
          return const Center(
            child: AnimeSanLogo(
              height: 60,
              enableTitle: false,
              loading: true,
            ),
          );
        }
      },
    );
  }
}
