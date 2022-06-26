import 'package:animesan/components/dialogs/module_login_dialog.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class ModuleOptionConfig<T extends Module> extends StatefulWidget {
  final T module;

  const ModuleOptionConfig({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  State<ModuleOptionConfig<T>> createState() => _ModuleOptionConfigState<T>();
}

class _ModuleOptionConfigState<T extends Module> extends State<ModuleOptionConfig<T>> {
  final ModuleController _moduleController = Get.find<ModuleController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 15, right: 0),
      leading: SvgPicture.asset(
        height: 25,
        widget.module.icon,
        color: widget.module.color,
      ),
      title: Text(
        widget.module.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Switcher(
            value: widget.module.isEnabled,
            size: SwitcherSize.medium,
            switcherButtonRadius: 50,
            enabledSwitcherButtonRotate: true,
            iconOff: Icons.cancel_outlined,
            iconOn: Icons.done,
            colorOff: Colors.red.withOpacity(0.5),
            colorOn: appSecondaryColor,
            onChanged: (state) {
              if (widget.module.isEnabled == state) {
                return;
              }
              _moduleController.enableSwitchModule<T>(widget.module, state);
              setState(() {});
            },
          ),
          IconButton(
            onPressed: widget.module.isEnabled
                ? () => Get.dialog(
                      ModuleLoginDialog(
                        module: widget.module,
                      ),
                    )
                : null,
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}
