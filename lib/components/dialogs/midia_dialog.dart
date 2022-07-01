import 'dart:ui';

import 'package:animesan/components/cards/episodio_card.dart';
import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/delegates/choose_temporada.dart';
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
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: ChooseTemporada(anime: anime, selectedTemporada: _selectedTemporada),
                      floating: true,
                    ),
                    Obx(() {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) {
                            return EpisodioCard(
                              episodio: _selectedTemporada.value!.episodios[index],
                              height: 150,
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                            );
                          },
                          childCount: _selectedTemporada.value!.episodios.length,
                        ),
                      );
                    }),
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
}
