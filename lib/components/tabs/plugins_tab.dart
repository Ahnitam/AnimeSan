import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/modules_dialog.dart';
import 'package:animesan/components/module_option_config.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  bool init = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init = false;
    });
    super.initState();
  }

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
                child: CustomButtom(
                  color: appGreyColor.withOpacity(0.5),
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  onPressed: _moduleController.streamModulesEnabled.isEmpty
                      ? null
                      : () {
                          Get.dialog(
                            ModulesDialog(
                              modules: _moduleController.streamModulesEnabled,
                              onSelect: (module) => onSelectStreamPadrao(module as StreamModule),
                            ),
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: padraoOption(_moduleController.streamModulesEnabled),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _moduleController.streamModules.length,
                  (index) => ModuleOptionConfig(
                    module: _moduleController.streamModules[index],
                    onChange: (module, state) {
                      if (init) {
                        return;
                      }
                      setState(
                        () {
                          _moduleController.streamPadrao == module && !state ? _moduleController.streamPadrao = null : null;
                          _moduleController.enableSwitchModule(module, state);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onSelectStreamPadrao(StreamModule streamModule) {
    setState(() {
      _moduleController.streamPadrao = streamModule;
    });
  }

  List<Widget> padraoOption(List<StreamModule> streamsModules) {
    late List<Widget> lista;
    if (streamsModules.isEmpty) {
      _moduleController.streamPadrao = null;
      lista = [
        modulePadraoText(
          "Nenhum stream ativo no aplicativo",
        ),
      ];
    } else if (_moduleController.streamPadrao == null) {
      lista = [
        modulePadraoText(
          "Escolha um Stream Padrão",
        ),
      ];
    } else {
      lista = [
        Row(
          children: [
            SvgPicture.asset(
              _moduleController.streamPadrao!.icon,
              height: 25,
              color: _moduleController.streamPadrao!.color,
            ),
            const SizedBox(
              width: 10,
            ),
            modulePadraoText(_moduleController.streamPadrao!.name),
          ],
        )
      ];
    }
    if (streamsModules.isNotEmpty) {
      lista.add(const Icon(Icons.arrow_forward_ios_rounded));
    }
    return lista;
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
