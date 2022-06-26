import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/components/item_module.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/components/search_with_buttom.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final ModuleController _moduleController = Get.find<ModuleController>();

  Home({Key? key}) : super(key: key);

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
              onClickLeading: _moduleController.getModules<StreamModule>(isEnabled: true).isNotEmpty
                  ? () => Get.dialog(
                        ItemSelectDialog<StreamModule>(
                          items: _moduleController.getModules<StreamModule>(isEnabled: true),
                          onSelect: (module, _) => _moduleController.setSelectedModule(module),
                          itemBuilder: (module) => ItemModule(
                            module: module,
                          ),
                        ),
                      )
                  : null,
              buscadorIcon: streamSelectedModule.value != null
                  ? SvgPicture.asset(
                      streamSelectedModule.value!.icon,
                      height: 30,
                      color: streamSelectedModule.value!.color,
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
}
