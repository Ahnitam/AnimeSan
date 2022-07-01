import 'dart:ui';

import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseTemporada extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  final Anime anime;

  late final Rx<Temporada?> selectedTemporada;

  ChooseTemporada({
    this.expandedHeight = 65,
    required this.anime,
    required this.selectedTemporada,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: expandedHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.loose,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(color: appGreyColor.withOpacity(0.6)),
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
                        onPressed: anime.temporadas.indexOf(selectedTemporada.value!) != 0 ? previusTemporada : null,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: anime.temporadas.indexOf(selectedTemporada.value!) != 0 ? Colors.white : appGreyColor,
                        ),
                      ),
                      Expanded(
                        child: CustomButtom(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          borderRadius: BorderRadius.zero,
                          color: Colors.transparent,
                          height: double.infinity,
                          onPressed: anime.temporadas.length > 1
                              ? () => Get.dialog(
                                    ItemSelectDialog<Temporada>(
                                      items: anime.temporadas,
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
                        onPressed: anime.temporadas.indexOf(selectedTemporada.value!) != anime.temporadas.length - 1 ? nextTemporada : null,
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: anime.temporadas.indexOf(selectedTemporada.value!) != anime.temporadas.length - 1 ? Colors.white : appGreyColor,
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
    selectedTemporada.value = anime.temporadas[anime.temporadas.indexOf(selectedTemporada.value!) - 1];
  }

  void nextTemporada() {
    selectedTemporada.value = anime.temporadas[anime.temporadas.indexOf(selectedTemporada.value!) + 1];
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
