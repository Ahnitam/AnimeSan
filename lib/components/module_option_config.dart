import 'package:animesan/components/dialogs/module_login_dialog.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class ModuleOptionConfig extends StatelessWidget {
  final StreamModule module;
  final void Function(StreamModule, bool) onChange;
  const ModuleOptionConfig({
    Key? key,
    required this.module,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 15, right: 0),
      leading: SvgPicture.asset(
        height: 25,
        module.icon,
        color: module.color,
      ),
      title: Text(
        module.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Switcher(
            value: module.isEnabled,
            size: SwitcherSize.medium,
            switcherButtonRadius: 50,
            enabledSwitcherButtonRotate: true,
            iconOff: Icons.cancel_outlined,
            iconOn: Icons.done,
            colorOff: Colors.red.withOpacity(0.5),
            colorOn: appSecondaryColor,
            onChanged: (state) {
              onChange(module, state);
            },
          ),
          IconButton(
            onPressed: module.isEnabled
                ? () => Get.dialog(
                      ModuleLoginDialog(
                        module: module,
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
