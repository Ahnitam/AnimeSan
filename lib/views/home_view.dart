import 'package:animesan/components/anime_search.dart';
import 'package:animesan/components/dialogs/midia_dialog.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final double toolbarHeight = 100;
  final EdgeInsets toolbarPadding = const EdgeInsets.only(top: 15, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: AnimeSearch<StreamModule>(
        appBar: (isSearching) => SliverAppBar(
          toolbarHeight: toolbarHeight + (toolbarPadding.top + toolbarPadding.bottom),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Hero(
            tag: "appLogo",
            child: AnimeSanLogo(
              height: toolbarHeight,
              loading: isSearching,
              margin: toolbarPadding,
            ),
          ),
        ),
        onAnimeSelected: (anime) => Get.dialog(
          MidiaDialog(anime: anime),
          barrierDismissible: false,
          barrierColor: Colors.transparent,
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        isOpenOnStart: false,
        backgroundColor: appPrimaryColor,
        overlayColor: appGreyColor,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.settings_rounded,
              color: appBlackColor,
            ),
            backgroundColor: appPrimaryColor,
            label: "Configuração",
            onTap: () => Get.toNamed("/config"),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.download_for_offline_rounded,
              color: appBlackColor,
            ),
            backgroundColor: appPrimaryColor,
            label: "Downloads",
            // onTap: () => Get.toNamed("/download"),
          ),
        ],
      ),
    );
  }
}
