import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/components/item_module.dart';
import 'package:animesan/components/search_with_buttom.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AnimeSearchDelegate<T extends Module> extends SliverPersistentHeaderDelegate {
  final ModuleController _moduleController = Get.find<ModuleController>();

  late final Rx<T?> _selectedModule;

  final void Function(String text) _onSubmited;

  final String? _searchText;
  final bool enableLeading;
  final Color? backgroundColor;

  final double height = 60;

  AnimeSearchDelegate({
    required void Function(String text) onSubmit,
    String? searchText,
    this.backgroundColor,
    this.enableLeading = true,
  })  : _onSubmited = onSubmit,
        _searchText = searchText {
    _selectedModule = _moduleController.getSelectedModule<T>();
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Obx(
      () => SearchButtom(
        backgroudColor: backgroundColor,
        text: _searchText,
        height: height,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        label: "ANIME",
        onSubmit: _selectedModule.value != null
            ? _onSubmit
            : (_) => Get.snackbar(
                  "Nenhum plugin selecionado",
                  "Selecione um plugin para fazer a busca",
                  backgroundColor: appWarningColor.withOpacity(0.4),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(10),
                  animationDuration: const Duration(milliseconds: 500),
                  duration: const Duration(seconds: 2),
                ),
        onClickLeading: enableLeading
            ? () => _moduleController.getModules<T>(isEnabled: true).isNotEmpty
                ? Get.dialog(
                    ItemSelectDialog<T>(
                      items: _moduleController.getModules<T>(isEnabled: true),
                      onSelect: (module) => _moduleController.setSelectedModule<T>(module),
                      itemBuilder: (module) => ItemModule(
                        module: module,
                      ),
                    ),
                  )
                : Get.snackbar(
                    "Nenhum plugin ativo",
                    "Ative algum plugin para fazer a busca",
                    backgroundColor: appWarningColor.withOpacity(0.4),
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(10),
                    animationDuration: const Duration(milliseconds: 500),
                    duration: const Duration(seconds: 2),
                  )
            : null,
        buscadorIcon: _selectedModule.value != null
            ? SvgPicture.asset(
                _selectedModule.value!.icon,
                height: 30,
                color: _selectedModule.value!.color,
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
    _onSubmited(text);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
