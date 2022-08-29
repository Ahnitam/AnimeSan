import 'package:animesan/components/cards/anime_card.dart';
import 'package:animesan/components/delegates/anime_search_delegate.dart';
import 'package:animesan/controllers/cached_animes.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/exceptions/login_exception.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimeSearch<T extends Module> extends StatefulWidget {
  final void Function(Anime) onAnimeSelected;
  final Widget Function(bool isSearching)? appBar;
  final String? initialValue;
  final bool enableLeading;
  final Color? backgroundColor;

  const AnimeSearch({
    Key? key,
    required this.onAnimeSelected,
    this.enableLeading = true,
    this.appBar,
    this.backgroundColor,
    this.initialValue,
  }) : super(key: key);

  @override
  State<AnimeSearch<T>> createState() => _AnimeSearchState<T>();
}

class _AnimeSearchState<T extends Module> extends State<AnimeSearch<T>> {
  final ModuleController _moduleController = Get.find<ModuleController>();
  final MidiaController _midiaController = Get.find<MidiaController>();
  final CachedAnimes _cachedAnimes = Get.find<CachedAnimes>();

  final Rx<SearchState> _searchState = Rx<SearchState>(SearchState.inicial);

  List<Anime> animes = const [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buscarAnime(widget.initialValue!);
      });
    }
  }

  void _buscarAnime(String query) {
    _searchState.value = SearchState.carregando;
    _midiaController.searchAnime<T>(query).then((animesSearched) {
      if (animesSearched.isEmpty) {
        _searchState.value = SearchState.vazio;
      } else {
        animes = animesSearched;
        _searchState.value = SearchState.sucesso;
      }
    }, onError: (e) {
      if (e.runtimeType == UnlogedException) {
        Get.snackbar(
          "Faça Login",
          "Faça login para poder pesquisar",
          backgroundColor: appWarningColor.withOpacity(0.4),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(seconds: 2),
        );
        _searchState.value = SearchState.inicial;
      } else {
        Get.snackbar(
          "Erro ao Buscar",
          "Erro do plugin ao realizar busca",
          backgroundColor: appErrorColor.withOpacity(0.4),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(seconds: 2),
        );
        _searchState.value = SearchState.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: []
          ..addIf(
            widget.appBar != null,
            Obx(
              () {
                return widget.appBar?.call(_searchState.value == SearchState.carregando) ?? const SliverAppBar();
              },
            ),
          )
          ..addAll(
            [
              SliverPersistentHeader(
                // pinned: true,
                // floating: true,
                delegate: AnimeSearchDelegate<T>(
                  backgroundColor: widget.backgroundColor,
                  enableLeading: widget.enableLeading,
                  onSubmit: (texto) {
                    _buscarAnime(texto);
                  },
                  searchText: widget.initialValue,
                ),
              ),
              Obx(
                () {
                  switch (_searchState.value) {
                    case SearchState.carregando:
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case SearchState.sucesso:
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return AnimeCard(
                              anime: animes[index],
                              margin: EdgeInsets.fromLTRB(10, 10, 10, index == animes.length - 1 ? 10 : 0),
                              onClick: (anime) {
                                _moduleController.setSelectedModule<T>(anime.module);
                                widget.onAnimeSelected(_cachedAnimes.getAnimeCached(animeSearched: anime));
                              },
                            );
                          },
                          childCount: animes.length,
                        ),
                      );
                    case SearchState.vazio:
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text("Nenhum resultado encontrado"),
                        ),
                      );
                    case SearchState.error:
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text("Error"),
                        ),
                      );
                    default:
                      return SliverToBoxAdapter(child: Container());
                  }
                },
              ),
            ],
          ),
      ),
    );
  }
}
