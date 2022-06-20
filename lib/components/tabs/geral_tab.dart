import 'package:animesan/controllers/settings_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class GeralTabConfig extends StatelessWidget with TabConfig {
  GeralTabConfig({Key? key}) : super(key: key);

  final SettingsController _controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        option("Forçar Dual Áudio", _controller.forceDualAudio),
      ],
    );
  }

  Widget option(String option, bool value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(option),
          Switcher(
            value: value,
            size: SwitcherSize.medium,
            switcherButtonRadius: 50,
            enabledSwitcherButtonRotate: true,
            iconOff: Icons.cancel_outlined,
            iconOn: Icons.done,
            colorOff: Colors.red.withOpacity(0.5),
            colorOn: appSecondaryColor,
            onChanged: (bool state) {
              _controller.forceDualAudio = state;
            },
          ),
        ],
      ),
    );
  }

  @override
  String get tabTitle => "Configurações gerais";

  @override
  IconData get tabIcon => Icons.settings_applications;
}
