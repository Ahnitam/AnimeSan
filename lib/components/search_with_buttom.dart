import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';

class SearchButtom extends StatelessWidget {
  final TextEditingController textBuscarController = TextEditingController();
  final String label;
  final double height;
  final double radius;
  final Color backgroudColor;
  final Color searchButtomColor;
  final Widget? buscadorIcon;
  final EdgeInsets margin;
  final void Function(String) onSubmit;
  final void Function()? onClickLeading;

  SearchButtom({
    Key? key,
    required this.label,
    required this.onSubmit,
    required this.onClickLeading,
    this.radius = 25,
    this.height = 50,
    this.backgroudColor = appGreyColor,
    this.searchButtomColor = appPrimaryColor,
    this.margin = const EdgeInsets.all(0),
    this.buscadorIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: height,
          color: backgroudColor,
          child: Row(
            children: [
              CustomButtom(
                height: double.infinity,
                padding: const EdgeInsets.only(left: 10, right: 10),
                color: Colors.transparent,
                splashEnabled: true,
                borderRadius: BorderRadius.zero,
                onPressed: onClickLeading,
                child: buscadorIcon ?? const Icon(Icons.warning_rounded, color: Colors.red),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      onSubmit(textBuscarController.text);
                    },
                    keyboardType: TextInputType.text,
                    controller: textBuscarController,
                    textAlignVertical: TextAlignVertical.bottom,
                    style: const TextStyle(
                      fontFamily: "Bree Serif",
                      color: appWhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 5, 0.0),
                      isDense: true,
                      labelText: label,
                      labelStyle: const TextStyle(
                        fontFamily: "Bree Serif",
                        color: appWhiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CustomButtom(
                borderRadius: BorderRadius.zero,
                height: double.infinity,
                width: 70,
                color: searchButtomColor,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onSubmit(textBuscarController.text);
                },
                child: const Icon(
                  Icons.search_rounded,
                  color: appBlackColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
