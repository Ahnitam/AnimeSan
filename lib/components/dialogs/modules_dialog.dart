import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ModulesDialog extends StatelessWidget {
  final List<Module> modules;
  final void Function(Module) onSelect;
  const ModulesDialog({Key? key, required this.modules, required this.onSelect}) : super(key: key);

  final radius = 20.0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: 250,
          ),
          decoration: BoxDecoration(
            color: appGreyColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              modules.length,
              (index) => option(modules[index], onSelect),
            ),
          ),
        ),
      ),
    );
  }

  Widget option(Module module, void Function(Module) onSelect) {
    return CustomButtom(
      color: appGreyColor,
      height: 40,
      width: double.infinity,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.only(left: 10, right: 10),
      onPressed: () {
        onSelect(module);
        Get.back();
      },
      child: Row(
        children: [
          SvgPicture.asset(
            module.icon,
            color: module.color,
            height: 25,
          ),
          Expanded(
            child: Text(
              module.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: "Bree Serif",
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
