import 'package:animesan/models/anime.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final Color backgroudColor;
  final double height;
  final EdgeInsets margin;
  final double radius;
  final bool imageRadius;
  final bool imagePadding;
  final double padding;
  final void Function(Anime)? onClick;

  const AnimeCard({
    Key? key,
    required this.anime,
    this.margin = const EdgeInsets.all(0),
    this.padding = 10,
    this.height = 200,
    this.radius = 15,
    this.imageRadius = false,
    this.imagePadding = false,
    this.backgroudColor = const Color.fromARGB(255, 33, 33, 33),
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.transparent,
      child: Padding(
        padding: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () => onClick?.call(anime),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: backgroudColor,
              ),
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: imagePadding ? EdgeInsets.only(top: padding, bottom: padding, left: padding) : const EdgeInsets.all(0),
                    child: ClipRRect(
                      borderRadius: imageRadius || imagePadding ? BorderRadius.circular(radius) : BorderRadius.zero,
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/loading.gif",
                        placeholderFit: BoxFit.none,
                        placeholderScale: 6,
                        image: anime.imageUrl!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: ((imagePadding ? height - (padding * 2) : height) * 240) / 360,
                        imageErrorBuilder: (context, obj, error) {
                          return Image.asset(
                            "assets/sem_imagem.png",
                            height: double.infinity,
                            width: ((imagePadding ? height - (padding * 2) : height) * 240) / 360,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: padding, bottom: 10, left: padding, right: padding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Text(
                                  anime.titulo,
                                  textAlign: TextAlign.center,
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
                            height: 10,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                anime.descricao,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Bree Serif",
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
