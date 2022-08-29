import 'package:animesan/components/anime_info.dart';
import 'package:animesan/components/anime_search.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/cached_animes.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:animesan/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectVariantEpisode<T extends Module> extends StatelessWidget {
  final Episodio episodio;
  SelectVariantEpisode({Key? key, required this.episodio}) : super(key: key);

  final ModuleController _moduleController = Get.find<ModuleController>();
  final MidiaController _midiaController = Get.find<MidiaController>();
  final CachedAnimes _cachedAnimes = Get.find<CachedAnimes>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: appGreyColor,
          width: double.infinity,
          height: double.infinity,
          child: Obx(_body),
        ),
      ),
    );
  }

  Widget _body() {
    if (_midiaController.externalIdsState.value == ExternalIdState.carregado) {
      return ObxValue<Rx<String?>>(
        (externalId) {
          if (externalId.value == null) {
            return _bodySearch(externalId);
          } else {
            final Anime cachedAnime = _cachedAnimes.getAnimeCached(
              animeSearched: episodio.temporada.anime.copyWith(
                id: externalId.value,
                temporadas: List.empty(growable: true),
                module: _moduleController.getSelectedModule<T>().value!,
              ),
            );
            return _bodyEpisodes(cachedAnime);
          }
        },
        Rx<String?>(
          _midiaController.getAnimeExternalId(episodio.temporada.anime, _moduleController.getSelectedModule<T>().value),
        ),
      );
    } else {
      return const Center(
        child: AnimeSanLogo(
          enableTitle: false,
          loading: true,
          height: 30,
        ),
      );
    }
  }

  Widget _bodySearch(Rx<String?> idExternal) {
    return AnimeSearch<T>(
      appBar: (_) => _appBar(),
      backgroundColor: appBlackColor,
      enableLeading: T != StreamModule,
      onAnimeSelected: (anime) {
        _midiaController.setAnimeExternalId(episodio.temporada.anime, anime);
        idExternal.value = anime.id;
      },
      initialValue: episodio.temporada.anime.titulo,
    );
  }

  Widget _bodyEpisodes(Anime anime) {
    return AnimeInfo(
      appBar: _appBar(),
      anime: anime,
      selectedTemporadaType: Rx(EpisodeType.leg),
      backgroundAnimeImage: false,
      onClickEpisode: (episodio) {
        this.episodio.mediasId[EpisodeType.leg] = episodio.mediasId[EpisodeType.leg]!;
        Get.back();
      },
    );
  }

  Widget _appBar() {
    final Module? selectedModule = _moduleController.getSelectedModule<T>().value;
    return SliverAppBar(
      pinned: true,
      backgroundColor: appGreyColor,
      title: Text("S${episodio.temporada.numero}E${episodio.numero}"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: (selectedModule != null
                  ? SvgPicture.asset(
                      selectedModule.icon,
                      height: 30,
                      color: selectedModule.color,
                    )
                  : null) ??
              const Icon(Icons.warning_rounded, color: Colors.red),
        ),
      ],
    );
  }
}
