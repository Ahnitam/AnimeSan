import 'package:animesan/components/anime_info.dart';
import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/item_select_dialog.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MidiaDialog extends StatelessWidget {
  final Anime anime;

  MidiaDialog({Key? key, required this.anime})
      : _selectedTemporadaType = Rx<EpisodeType?>(anime.temporadasEpisodeTypes.isNotEmpty ? anime.temporadasEpisodeTypes[0] : null),
        super(key: key);

  final Rx<EpisodeType?> _selectedTemporadaType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: appBackgroudColor,
      child: AnimeInfo(
        anime: anime,
        selectedTemporadaType: _selectedTemporadaType,
        appBar: Obx(() {
          return SliverAppBar(
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
            actions: []..addIf(
                _selectedTemporadaType.value != null,
                CustomButtom(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  height: double.infinity,
                  width: 50,
                  onPressed: anime.temporadasEpisodeTypes.length > 1
                      ? () => Get.dialog(
                            ItemSelectDialog<EpisodeType>(
                              selectedItem: _selectedTemporadaType.value,
                              items: anime.temporadasEpisodeTypes,
                              onSelect: (temporadaType) => _selectedTemporadaType.value = temporadaType,
                              itemBuilder: (temporadaType) => Text(
                                temporadaType.label,
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
                    _selectedTemporadaType.value!.name,
                    style: const TextStyle(
                      fontFamily: "Bree Serif",
                      fontSize: 12,
                      color: appWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            pinned: false,
            floating: false,
          );
        }),
      ),
    );
  }
}
