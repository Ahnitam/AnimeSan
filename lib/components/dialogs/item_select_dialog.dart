import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemSelectDialog<T> extends StatelessWidget {
  final List<T> items;
  final void Function(T) onSelect;
  final Widget Function(T) itemBuilder;
  final T? selectedItem;
  const ItemSelectDialog({Key? key, required this.items, required this.onSelect, required this.itemBuilder, this.selectedItem}) : super(key: key);

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
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: appGreyColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: items.isNotEmpty
                  ? List.generate(
                      items.length,
                      (index) => CustomButtom(
                        color: selectedItem == items[index] ? appSecondaryColor : appGreyColor,
                        height: 40,
                        width: double.infinity,
                        borderRadius: BorderRadius.zero,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        onPressed: () {
                          onSelect(items[index]);
                          Get.back();
                        },
                        child: itemBuilder(items[index]),
                      ),
                    )
                  : [
                      const SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            "Nenhuma opção",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
