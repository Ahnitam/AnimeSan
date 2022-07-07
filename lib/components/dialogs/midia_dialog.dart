import 'package:animesan/components/cards/episodio_card.dart';
import 'package:animesan/components/delegates/choose_temporada.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/temporada.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
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
      child: Obx(
        () {
          if (anime.state.value == MidiaState.error) {
            return const Center(
              child: Text("Error"),
            );
          } else if (anime.state.value == MidiaState.carregado) {
            if (anime.temporadas.isEmpty) {
              return const Center(
                child: Text("Sem Temporadas"),
              );
            } else {
              _selectedTemporada.value = anime.temporadas.first;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(anime.imageUrl),
                    onError: (_, __) {
                      debugPrint("Erro ao carregar imagem");
                    },
                    fit: BoxFit.cover,
                    opacity: 0.3,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                  ),
                ),
                height: double.infinity,
                width: double.infinity,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          anime.titulo,
                          style: const TextStyle(
                            fontFamily: "Bree Serif",
                            fontSize: 14,
                            color: appWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      centerTitle: true,
                      pinned: false,
                      floating: false,
                    ),
                    SliverPersistentHeader(
                      delegate: ChooseTemporada(anime: anime, selectedTemporada: _selectedTemporada),
                      floating: true,
                    ),
                    Obx(() {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) {
                            return EpisodioCard(
                              midiaController: _midiaController,
                              episodio: _selectedTemporada.value!.episodios[index],
                              height: 150,
                              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
            if (anime.state.value == MidiaState.inicial) {
              _midiaController.fetchAnime(anime);
            }
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
