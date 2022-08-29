import 'dart:ui';

import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseTemporada extends SliverPersistentHeaderDelegate {
  late final double _expandedHeight;

  final List<Temporada> _temporadas;
  late final Rx<Temporada?> selectedTemporada;

  final double height;
  final EdgeInsets margin;

  ChooseTemporada({
    this.height = 55,
    this.margin = const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    required List<Temporada> temporadas,
    required this.selectedTemporada,
  })  : _temporadas = temporadas,
        _expandedHeight = height + margin.top + margin.bottom;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.loose,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(color: appSecondaryColor.withOpacity(0.6)),
                  ),
                ),
              ),
              Obx(
                () {
                  return Row(
                    children: [
                      CustomButtom(
                        padding: const EdgeInsets.only(left: 10),
                        height: double.infinity,
                        borderRadius: BorderRadius.zero,
                        width: 60,
                        color: Colors.transparent,
                        onPressed: _temporadas.indexOf(selectedTemporada.value!) != 0 ? previusTemporada : null,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: _temporadas.indexOf(selectedTemporada.value!) != 0 ? Colors.white : appGreyColor,
                        ),
                      ),
                      Expanded(
                        child: CustomButtom(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          borderRadius: BorderRadius.zero,
                          color: Colors.transparent,
                          height: double.infinity,
                          onPressed: _temporadas.length > 1
                              ? () => Get.dialog(
                                    ItemSelectDialog<Temporada>(
                                      selectedItem: selectedTemporada.value,
                                      items: _temporadas,
                                      onSelect: (temporada) => selectedTemporada.value = temporada,
                                      itemBuilder: (temporada) => Text(
                                        temporada.titulo,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Bree Serif",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                              : null,
                          child: Text(
                            selectedTemporada.value!.titulo,
                            style: const TextStyle(
                              fontFamily: "Bree Serif",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      CustomButtom(
                        height: double.infinity,
                        borderRadius: BorderRadius.zero,
                        width: 60,
                        color: Colors.transparent,
                        onPressed: _temporadas.indexOf(selectedTemporada.value!) != _temporadas.length - 1 ? nextTemporada : null,
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: _temporadas.indexOf(selectedTemporada.value!) != _temporadas.length - 1 ? Colors.white : appGreyColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void previusTemporada() {
    selectedTemporada.value = _temporadas[_temporadas.indexOf(selectedTemporada.value!) - 1];
  }

  void nextTemporada() {
    selectedTemporada.value = _temporadas[_temporadas.indexOf(selectedTemporada.value!) + 1];
  }

  @override
  double get maxExtent => _expandedHeight;

  @override
  double get minExtent => _expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
