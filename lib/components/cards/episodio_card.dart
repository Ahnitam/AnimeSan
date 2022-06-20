import 'dart:ui';

import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EpisodioCard extends StatefulWidget {
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
  }) : super(key: key);

  @override
  State<EpisodioCard> createState() => _EpisodioCardState();
}

class _EpisodioCardState extends State<EpisodioCard> {
  bool optionsExpand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Padding(
        padding: widget.margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              color: widget.backgroudColor,
            ),
            height: widget.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                episodeImage(),
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

  Widget episodeImage() {
    return Padding(
      padding: widget.imagePadding
          ? EdgeInsets.only(
              top: widget.padding.top,
              bottom: widget.padding.bottom,
              left: widget.padding.left,
            )
          : const EdgeInsets.all(0),
      child: Container(
        height: double.infinity,
        color: Colors.black.withOpacity(0.5),
        constraints: BoxConstraints(
          maxWidth: context.width * 0.4 - (widget.imagePadding ? widget.padding.left : 0),
        ),
        child: ClipRRect(
          borderRadius: widget.imageRadius || widget.imagePadding ? BorderRadius.circular(widget.radius) : BorderRadius.zero,
          child: FadeInImage.assetNetwork(
            placeholder: "assets/loading.gif",
            placeholderFit: BoxFit.none,
            placeholderScale: 6,
            image: widget.episodio.imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: context.width * 0.4 - (widget.imagePadding ? widget.padding.left : 0),
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
            color: widget.iconButtomOptionColor,
            size: widget.iconButtomOptionSize,
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
      padding: EdgeInsets.only(top: widget.padding.top, bottom: widget.moreOptionsHeight, left: widget.padding.left, right: widget.padding.right),
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
              child: Text(
                widget.episodio.titulo,
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
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Text(
                widget.episodio.descricao,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontFamily: "Bree Serif",
                  color: Color.fromARGB(255, 167, 167, 167),
                  fontSize: 10,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              optionsExpand = !optionsExpand;
            }),
            child: Container(
              height: widget.moreOptionsHeight,
              color: widget.buttomOptionColor,
              width: double.infinity,
              child: Icon(
                optionsExpand ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: optionsExpand ? widget.height - widget.moreOptionsHeight : 0,
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
                  Row(
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
                                widget.episodio.download == null
                                    ? ""
                                    : widget.episodio.download!.tipo == MediaType.leg
                                        ? "Legendado"
                                        : widget.episodio.download!.tipo == MediaType.dub
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
                            Flexible(child: option(Icons.copy_rounded, "Copiar URL", onClick: () {})),
                            Flexible(child: option(Icons.cast_rounded, "Transmitir", onClick: () {})),
                            Flexible(child: option(Icons.cloud_download_rounded, "Download", onClick: () {})),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
