import 'package:animesan/components/custom_buttom.dart';
import 'package:flutter/material.dart';

class SearchButtom extends StatelessWidget {
  final TextEditingController textBuscarController = TextEditingController();
  final String label;
  final double height;
  final double radius;
  final Color color;
  final Color searchButtomColor;
  final Widget? buscadorIcon;
  final EdgeInsets margin;
  final void Function(String) onSubmit;

  SearchButtom({
    Key? key,
    required this.label,
    required this.onSubmit,
    this.radius = 25,
    this.height = 50,
    this.color = const Color.fromARGB(255, 33, 33, 33),
    this.searchButtomColor = const Color.fromARGB(169, 27, 94, 31),
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
          color: color,
          child: Row(
            children: [
              CustomButtom(
                height: double.infinity,
                padding: const EdgeInsets.only(left: 10, right: 10),
                color: Colors.transparent,
                splashEnabled: false,
                borderRadius: BorderRadius.zero,
                onPressed: () {
                  textBuscarController.clear();
                },
                child: buscadorIcon ?? const Icon(Icons.warning_rounded, color: Colors.red),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    onEditingComplete: () => onSubmit(textBuscarController.text),
                    keyboardType: TextInputType.text,
                    controller: textBuscarController,
                    textAlignVertical: TextAlignVertical.bottom,
                    style: const TextStyle(
                      fontFamily: "Bree Serif",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 5, 0.0),
                      isDense: true,
                      labelText: label,
                      labelStyle: const TextStyle(
                        fontFamily: "Bree Serif",
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(0, 0, 0, 0),
                          width: 0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(0, 0, 0, 0),
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
                onPressed: () => onSubmit(textBuscarController.text),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
