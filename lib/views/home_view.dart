import 'package:animesan/components/cards/anime_card.dart';
import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/components/dialogs/midia_dialog.dart';
import 'package:animesan/components/item_module.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/components/search_with_buttom.dart';
import 'package:animesan/controllers/cached_animes.dart';
import 'package:animesan/controllers/home_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final ModuleController _moduleController = Get.find<ModuleController>();
  late final HomeController _homeController;
  final CachedAnimes _cachedAnimes = Get.find<CachedAnimes>();

  Home({Key? key}) : super(key: key) {
    _homeController = HomeController(moduleController: _moduleController);
  }

  @override
  Widget build(BuildContext context) {
    final Rx<StreamModule?> streamSelectedModule = _moduleController.getSelectedModule<StreamModule>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Obx(() {
            return Hero(
              tag: "appLogo",
              child: AnimeSanLogo(
                loading: _homeController.searchState.value == SearchState.carregando ? true : false,
                margin: const EdgeInsets.only(top: 15, bottom: 10),
              ),
            );
          }),
          Obx(
            () => SearchButtom(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              label: "ANIME",
              onSubmit: streamSelectedModule.value != null
                  ? _onSubmit
                  : (_) => Get.snackbar(
                        "Nenhum plugin selecionado",
                        "Selecione um plugin de streaming",
                        backgroundColor: appWarningColor.withOpacity(0.4),
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(10),
                        animationDuration: const Duration(milliseconds: 500),
                        duration: const Duration(seconds: 2),
                      ),
              onClickLeading: () => _moduleController.getModules<StreamModule>(isEnabled: true).isNotEmpty
                  ? Get.dialog(
                      ItemSelectDialog<StreamModule>(
                        items: _moduleController.getModules<StreamModule>(isEnabled: true),
                        onSelect: (module) => _moduleController.setSelectedModule(module),
                        itemBuilder: (module) => ItemModule(
                          module: module,
                        ),
                      ),
                    )
                  : Get.snackbar(
                      "Nenhum plugin ativo",
                      "Ative algum plugin de streaming",
                      backgroundColor: appWarningColor.withOpacity(0.4),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(10),
                      animationDuration: const Duration(milliseconds: 500),
                      duration: const Duration(seconds: 2),
                    ),
              buscadorIcon: streamSelectedModule.value != null
                  ? SvgPicture.asset(
                      streamSelectedModule.value!.icon,
                      height: 30,
                      color: streamSelectedModule.value!.color,
                    )
                  : null,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Obx(() {
                if (_homeController.searchState.value == SearchState.carregando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_homeController.searchState.value == SearchState.sucesso) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _homeController.animes.length,
                    itemBuilder: (_, index) => AnimeCard(
                      anime: _homeController.animes[index],
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      onClick: (anime) => Get.dialog(
                        MidiaDialog(anime: _cachedAnimes.getAnimeCached(animeSearched: anime)),
                        barrierDismissible: false,
                        barrierColor: Colors.transparent,
                      ),
                    ),
                  );
                }
                return Container();
              }),
            ),
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

  void _onSubmit(String text) {
    if (text.length < 4) {
      Get.snackbar(
        "Busca muito curta",
        "Digite mais de 3 caracteres para fazer uma busca",
        backgroundColor: appErrorColor.withOpacity(0.4),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 2),
      );
      return;
    }
    _homeController.searchAnime(text);
  }
}
