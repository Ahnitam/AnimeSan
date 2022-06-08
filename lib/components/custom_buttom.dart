import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Widget child;
  final double? width;
  final double height;
  final double fontSize;
  final Color? color;
  final VoidCallback? onPressed;
  late final BorderRadius borderRadius;

  CustomButtom({
    Key? key,
    required this.child,
    this.onPressed,
    this.fontSize = 10,
    this.width,
    required this.height,
    this.color,
    BorderRadius? borderRadius,
  }) : super(key: key) {
    this.borderRadius = borderRadius ?? BorderRadius.circular(20);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        color: color ?? const Color.fromARGB(169, 27, 94, 31),
        height: height,
        width: width,
        child: RawMaterialButton(
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
