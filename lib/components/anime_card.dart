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
                      child: Image.network(
                        anime.imageUrl!,
                        height: double.infinity,
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                anime.titulo,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
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
