import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AnimeSanLogo extends StatefulWidget {
  final EdgeInsets margin;
  final double height;
  final bool loading;
  final bool enableLogo;
  final bool enableShadowLogo;
  final bool enableTitle;
  final bool enableShadowTitle;
  const AnimeSanLogo({
    Key? key,
    this.height = 100,
    this.loading = false,
    this.margin = EdgeInsets.zero,
    this.enableLogo = true,
    this.enableShadowLogo = false,
    this.enableTitle = true,
    this.enableShadowTitle = false,
  }) : super(key: key);

  @override
  State<AnimeSanLogo> createState() => _AnimeSanLogoState();
}

class _AnimeSanLogoState extends State<AnimeSanLogo> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
  @override
  Widget build(BuildContext context) {
    widget.loading ? _controller.repeat() : _controller.forward();
    return Padding(
      padding: widget.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.enableLogo
              ? RotationTransition(
                  turns: _animation,
                  child: SimpleShadow(
                    opacity: widget.enableShadowLogo ? 0.4 : 0,
                    offset: const Offset(1, 1),
                    sigma: 5,
                    child: SvgPicture.asset(
                      "assets/shuriken.svg",
                      height: widget.height * 0.8,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          SizedBox(
            width: widget.enableLogo && widget.enableTitle ? 10 : 0,
          ),
          widget.enableTitle
              ? SimpleShadow(
                  opacity: widget.enableShadowTitle ? 0.4 : 0,
                  offset: const Offset(1, 1),
                  sigma: 6,
                  child: SvgPicture.asset(
                    "assets/text.svg",
                    height: 95,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
