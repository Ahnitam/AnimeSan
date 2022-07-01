import 'dart:ui';

import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MidiaDialog extends StatelessWidget {
  final Anime anime;

  final Rx<Temporada?> _selectedTemporada = Rx<Temporada?>(null);
  MidiaDialog({Key? key, required this.anime}) : super(key: key);

  final MidiaController _midiaController = MidiaController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: appBackgroudColor,
      child: FutureBuilder(
        future: _midiaController.fetchAnime(anime),
        builder: (_, AsyncSnapshot<Anime> animeSnapshot) {
          if (animeSnapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (animeSnapshot.hasData) {
            if (anime.temporadas.isEmpty) {
              return const Center(
                child: Text("Sem Temporadas"),
              );
            } else {
              _selectedTemporada.value = anime.temporadas.first;
              return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      decoration: BoxDecoration(color: appGreyColor.withOpacity(0.4)),
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
                                          onPressed: anime.temporadas.indexOf(_selectedTemporada.value!) != 0 ? previusTemporada : null,
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: anime.temporadas.indexOf(_selectedTemporada.value!) != 0 ? Colors.white : appGreyColor,
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
                                                        onSelect: (temporada) => _selectedTemporada.value = temporada,
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
                                              _selectedTemporada.value!.titulo,
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
                                          onPressed: anime.temporadas.indexOf(_selectedTemporada.value!) != anime.temporadas.length - 1
                                              ? nextTemporada
                                              : null,
                                          child: Center(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: anime.temporadas.indexOf(_selectedTemporada.value!) != anime.temporadas.length - 1
                                                  ? Colors.white
                                                  : appGreyColor,
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
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(
              child: AnimeSanLogo(
                height: 60,
                enableTitle: false,
                loading: true,
              ),
            );
          }
        },
      ),
    );
  }

  void previusTemporada() {
    _selectedTemporada.value = anime.temporadas[anime.temporadas.indexOf(_selectedTemporada.value!) - 1];
  }

  void nextTemporada() {
    _selectedTemporada.value = anime.temporadas[anime.temporadas.indexOf(_selectedTemporada.value!) + 1];
  }
}
