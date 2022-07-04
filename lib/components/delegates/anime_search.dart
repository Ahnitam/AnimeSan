import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/components/item_module.dart';
import 'package:animesan/components/search_with_buttom.dart';
import 'package:animesan/controllers/home_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AnimeSearch extends SliverPersistentHeaderDelegate {
  late final Rx<StreamModule?> _streamSelectedModule;
  final HomeController _homeController;
  final ModuleController _moduleController;
  final double height = 60;

  AnimeSearch({required HomeController homeController})
      : _homeController = homeController,
        _moduleController = Get.find<ModuleController>() {
    _streamSelectedModule = _moduleController.getSelectedModule<StreamModule>();
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Obx(
      () => SearchButtom(
        height: height,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        label: "ANIME",
        onSubmit: _streamSelectedModule.value != null
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
        buscadorIcon: _streamSelectedModule.value != null
            ? SvgPicture.asset(
                _streamSelectedModule.value!.icon,
                height: 30,
                color: _streamSelectedModule.value!.color,
              )
            : null,
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

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
