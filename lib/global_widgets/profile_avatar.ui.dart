import 'package:flutter/material.dart';
import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/icons.res.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = 68.0,
    this.padding = 6.0,
    required this.onTap,
  });

  final double size;
  final double padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const borderSize = 2.0;
    return Tooltip(
      message: 'Profile Image',
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => Container(
              width: size - padding - borderSize,
              height: size - padding - borderSize,
              padding: EdgeInsets.all(padding * 0.5),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: grayScale50,
              ),
              child: SvgPicture.asset(userActiveIcon)),
        ),
      ),
    );
  }
}
