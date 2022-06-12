import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool splashEnabled;
  final VoidCallback? onPressed;
  late final BorderRadius borderRadius;
  final EdgeInsets padding;

  CustomButtom({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.splashEnabled = true,
    this.onPressed,
    this.color,
    this.padding = EdgeInsets.zero,
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
          constraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          highlightColor: splashEnabled ? null : Colors.transparent,
          splashColor: splashEnabled ? null : Colors.transparent,
          padding: padding,
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
