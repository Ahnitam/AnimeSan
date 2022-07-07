import 'dart:ui';

import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:animesan/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class EpisodioCard extends StatelessWidget {
  final Episodio episodio;
  final Color backgroudColor;
  final double height;
  final EdgeInsets margin;
  final double radius;
  final bool imageRadius;
  final bool imagePadding;
  final EdgeInsets padding;
  final double moreOptionsHeight;
  final Color buttomOptionColor;
  final Color iconButtomOptionColor;
  final double iconButtomOptionSize;

  final MidiaController _midiaController;

  const EpisodioCard({
    Key? key,
    required this.episodio,
    this.margin = const EdgeInsets.all(0),
    this.buttomOptionColor = const Color.fromARGB(255, 0, 196, 131),
    this.iconButtomOptionColor = Colors.black,
    this.iconButtomOptionSize = 14.0,
    this.moreOptionsHeight = 10,
    this.padding = const EdgeInsets.all(10),
    this.height = 200,
    this.radius = 15,
    this.imageRadius = false,
    this.imagePadding = false,
    this.backgroudColor = appGreyColor,
    required MidiaController midiaController,
  })  : _midiaController = midiaController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: backgroudColor,
            ),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                episodeImage(context),
                Expanded(
                  child: Stack(
                    children: [
                      titleDescription(),
                      moreOptions(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget episodeImage(BuildContext context) {
    return Padding(
      padding: imagePadding
          ? EdgeInsets.only(
              top: padding.top,
              bottom: padding.bottom,
              left: padding.left,
            )
          : const EdgeInsets.all(0),
      child: Container(
        height: double.infinity,
        color: Colors.black.withOpacity(0.5),
        constraints: BoxConstraints(
          maxWidth: context.width * 0.4 - (imagePadding ? padding.left : 0),
        ),
        child: ClipRRect(
          borderRadius: imageRadius || imagePadding ? BorderRadius.circular(radius) : BorderRadius.zero,
          child: FadeInImage.assetNetwork(
            placeholder: "assets/loading.gif",
            placeholderFit: BoxFit.none,
            placeholderScale: 6,
            image: episodio.imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: context.width * 0.4 - (imagePadding ? padding.left : 0),
            imageErrorBuilder: (context, obj, error) {
              return const Center(child: Text("No Image"));
            },
          ),
        ),
      ),
    );
  }

  CustomButtom option(IconData icon, String label, {VoidCallback? onClick}) {
    return CustomButtom(
      height: 30,
      padding: const EdgeInsets.only(left: 10, right: 10),
      onPressed: onClick,
      color: const Color.fromARGB(255, 0, 196, 131),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconButtomOptionColor,
            size: iconButtomOptionSize,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }

  Widget titleDescription() {
    return Padding(
      padding: EdgeInsets.only(top: padding.top, bottom: moreOptionsHeight, left: padding.left, right: padding.right),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () => _copyToClipboard(episodio.titulo),
                onLongPress: _setToModuleInfo,
                child: Text(
                  episodio.titulo,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "Bree Serif",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () => _copyToClipboard(episodio.descricao),
                onLongPress: _setToModuleInfo,
                child: Text(
                  episodio.descricao,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontFamily: "Bree Serif",
                    color: Color.fromARGB(255, 167, 167, 167),
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget moreOptions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ObxValue<Rx<bool>>(
        (optionsExpand) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (episodio.state.value == MidiaState.inicial) {
                    _midiaController.fetchDownload(episodio);
                  }
                  optionsExpand.value = !optionsExpand.value;
                },
                child: Container(
                  height: moreOptionsHeight,
                  color: buttomOptionColor,
                  width: double.infinity,
                  child: Icon(
                    optionsExpand.value ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: optionsExpand.value ? height - moreOptionsHeight : 0,
                  child: Stack(
                    children: [
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.0)),
                          ),
                        ),
                      ),
                      Obx(() {
                        if (episodio.state.value == MidiaState.error) {
                          return const Center(
                            child: Text("Error"),
                          );
                        } else if (episodio.state.value == MidiaState.carregado) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        episodio.download == null
                                            ? ""
                                            : episodio.download!.tipo == MediaType.leg
                                                ? "Legendado"
                                                : episodio.download!.tipo == MediaType.dub
                                                    ? "Dublado"
                                                    : "Dual Áudio",
                                        style: const TextStyle(fontFamily: "Bree Serif", fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: option(
                                        Icons.copy_rounded,
                                        "Copiar URL",
                                        onClick: () => _copyToClipboard(episodio.download!.tipo == MediaType.leg
                                            ? episodio.download!.hardsub.video.leg.url ?? ""
                                            : episodio.download!.hardsub.video.dub.url ?? ""),
                                      ),
                                    ),
                                    Flexible(
                                      child: option(
                                        Icons.cast_rounded,
                                        "Transmitir",
                                        onClick: () {
                                          Share.share(episodio.download!.tipo == MediaType.leg
                                              ? episodio.download!.hardsub.video.leg.url ?? ""
                                              : episodio.download!.hardsub.video.dub.url ?? "");
                                        },
                                      ),
                                    ),
                                    Flexible(child: option(Icons.cloud_download_rounded, "Download", onClick: () {})),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else if (episodio.state.value == MidiaState.carregando) {
                          return const Center(
                            child: AnimeSanLogo(
                              height: 30,
                              enableTitle: false,
                              loading: true,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        Rx<bool>(false),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then(
      (value) => Get.snackbar(
        "Copiado para a área de transferência",
        text,
        messageText: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appSucessColor,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _setToModuleInfo() {
    Get.snackbar(
      "Não Implementado",
      "Essa função ainda não está disponível",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: appErrorColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(20),
      duration: const Duration(milliseconds: 1500),
    );
  }
}
