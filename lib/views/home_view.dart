import 'package:animesan/components/dialogs/modules_dialog.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/components/search_with_buttom.dart';
import 'package:animesan/controllers/home_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final ModuleController _moduleController = Get.find<ModuleController>();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          const Hero(
            tag: "appLogo",
            child: AnimeSanLogo(
              loading: false,
              margin: EdgeInsets.only(top: 15, bottom: 10),
            ),
          ),
          Obx(
            () => SearchButtom(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              label: "ANIME",
              onSubmit: _onSubmit,
              onClickLeading: () => Get.dialog(
                ModulesDialog(
                  modules: _moduleController.streamModulesEnabled,
                  onSelect: (module) => _onSelectModule(module as StreamModule),
                ),
              ),
              buscadorIcon: _homeController.selectedStreamModule.value != null
                  ? SvgPicture.asset(
                      _homeController.selectedStreamModule.value!.icon,
                      height: 30,
                      color: _homeController.selectedStreamModule.value!.color,
                    )
                  : null,
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        isOpenOnStart: false,
        backgroundColor: const Color.fromARGB(255, 0, 128, 55),
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.black,
            ),
            backgroundColor: appPrimaryColor,
            label: "Configuração",
            onTap: () => Get.toNamed("/config"),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.download_for_offline_rounded,
              color: Colors.black,
            ),
            backgroundColor: appPrimaryColor,
            label: "Downloads",
            // onTap: () => Get.toNamed("/download"),
          ),
        ],
      ),
    );
  }

  void _onSubmit(String text) {}

  void _onSelectModule(StreamModule module) {
    _homeController.selectedStreamModule.value = module;
  }
}
