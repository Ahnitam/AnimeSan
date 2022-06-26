import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/modules_dialog.dart';
import 'package:animesan/components/item_module_dialog.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SelectStandardModule<T extends Module> extends StatelessWidget {
  SelectStandardModule({Key? key}) : super(key: key);

  final ModuleController _moduleController = Get.find<ModuleController>();

  @override
  Widget build(BuildContext context) {
    final Rx<T?> modulePadrao = _moduleController.getModulePadrao<T>();
    return Obx(
      () {
        final List<T> modulesEnabled = _moduleController.getModules<T>(isEnabled: true);
        return CustomButtom(
          color: appGreyColor.withOpacity(0.5),
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 10),
          onPressed: modulesEnabled.isEmpty
              ? null
              : () {
                  Get.dialog(
                    ModulesDialog<T>(
                      items: modulesEnabled,
                      onSelect: (module) => _moduleController.setModulePadrao<T>(module),
                      itemBuilder: (module) => ItemModuleDialog<T>(module: module),
                    ),
                  );
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _moduleController.getModulePadrao<T>().value == null
                  ? Text(
                      modulesEnabled.isNotEmpty ? "Escolha um Plugin Padrão" : "Nenhum Plugin Ativo no Aplicativo",
                    )
                  : Row(
                      children: [
                        SvgPicture.asset(
                          _moduleController.getModulePadrao<T>().value!.icon,
                          height: 25,
                          color: _moduleController.getModulePadrao<T>().value!.color,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        modulePadraoText(_moduleController.getModulePadrao<T>().value!.name),
                      ],
                    ),
            ]..addIf(modulesEnabled.isNotEmpty, const Icon(Icons.arrow_forward_ios_rounded)),
          ),
        );
      },
    );
  }

  Text modulePadraoText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Bree Serif",
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
