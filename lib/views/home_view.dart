import 'package:animesan/components/cards/anime_card.dart';
import 'package:animesan/components/delegates/anime_search.dart';
import 'package:animesan/components/dialogs/midia_dialog.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/cached_animes.dart';
import 'package:animesan/controllers/home_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final ModuleController _moduleController = Get.find<ModuleController>();
  final CachedAnimes _cachedAnimes = Get.find<CachedAnimes>();
  late final HomeController _homeController;

  Home({Key? key}) : super(key: key) {
    _homeController = HomeController(moduleController: _moduleController);
  }

  final double toolbarHeight = 100;
  final EdgeInsets toolbarPadding = const EdgeInsets.only(top: 15, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            toolbarHeight: toolbarHeight + (toolbarPadding.top + toolbarPadding.bottom),
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Obx(() {
              return Hero(
                tag: "appLogo",
                child: AnimeSanLogo(
                  height: toolbarHeight,
                  loading: _homeController.searchState.value == SearchState.carregando ? true : false,
                  margin: toolbarPadding,
                ),
              );
            }),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: AnimeSearch(homeController: _homeController),
          ),
          Obx(
            () {
              if (_homeController.searchState.value == SearchState.carregando) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (_homeController.searchState.value == SearchState.sucesso) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AnimeCard(
                        anime: _homeController.animes[index],
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        onClick: (anime) => Get.dialog(
                          MidiaDialog(anime: _cachedAnimes.getAnimeCached(animeSearched: anime)),
                          barrierDismissible: false,
                          barrierColor: Colors.transparent,
                        ),
                      );
                    },
                    childCount: _homeController.animes.length,
                  ),
                );
              }
              return SliverToBoxAdapter(child: Container());
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        isOpenOnStart: false,
        backgroundColor: appPrimaryColor,
        overlayColor: appGreyColor,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.settings_rounded,
              color: appBlackColor,
            ),
            backgroundColor: appPrimaryColor,
            label: "Configuração",
            onTap: () => Get.toNamed("/config"),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.download_for_offline_rounded,
              color: appBlackColor,
            ),
            backgroundColor: appPrimaryColor,
            label: "Downloads",
            // onTap: () => Get.toNamed("/download"),
          ),
        ],
      ),
    );
  }
}
