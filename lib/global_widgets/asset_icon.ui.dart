import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetIconButton extends StatelessWidget {
  const AssetIconButton({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.onTap,
  });

  final String icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: SvgPicture.asset(
          icon,
          width: size,
          height: size,
          color: color,
        ),
      ),
    );
  }
}
