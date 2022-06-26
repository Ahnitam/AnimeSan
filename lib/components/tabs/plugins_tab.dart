import 'package:animesan/components/module_option_config.dart';
import 'package:animesan/components/select_standard_module.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PluginsTabConfig extends StatefulWidget with TabConfig {
  PluginsTabConfig({Key? key}) : super(key: key);

  @override
  State<PluginsTabConfig> createState() => _PluginsTabConfigState();

  @override
  String get tabTitle => "Plugins";

  @override
  IconData get tabIcon => Icons.power_rounded;
}

class _PluginsTabConfigState extends State<PluginsTabConfig> {
  final ModuleController _moduleController = Get.find<ModuleController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: double.infinity,
          ),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Streams",
                style: TextStyle(
                  fontFamily: "Bree Serif",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.only(left: 15, right: 10),
                width: double.infinity,
                child: const Text(
                  "Padrão",
                  style: TextStyle(
                    fontFamily: "Bree Serif",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SelectStandardModule<StreamModule>(),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _moduleController.getModules<StreamModule>().length,
                  (index) => ModuleOptionConfig<StreamModule>(
                    module: _moduleController.getModules<StreamModule>()[index],
                    // modulePadrao: _moduleController.streamPadrao,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
