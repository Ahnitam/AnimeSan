import 'package:animesan/models/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemModule<T extends Module> extends StatelessWidget {
  final T module;
  const ItemModule({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          module.icon,
          color: module.color,
          height: 25,
        ),
        Expanded(
          child: Text(
            module.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontFamily: "Bree Serif",
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
