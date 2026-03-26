import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TrackIt/Resources/icons.res.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthBackButtonUi extends StatelessWidget {
  const AuthBackButtonUi({
    super.key,
    this.size,
    this.iconColor,
    this.backgroundColor,
  });

  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.pop(context);
      },
      // borderRadius: const BorderRadius.all(
      //   Radius.circular(100),
      // ),
      // child: Container(
      //   // width: ,
      //   // height: ,
      //   decoration: BoxDecoration(
      //     color: backgroundColor,
      //     borderRadius: const BorderRadius.all(
      //       Radius.circular(100),
      //     ),
      //     border: Border.all(
      //       color: iconColor ?? grayScale100,
      //     ),
      //   ),
      child: SvgPicture.asset(
        backIcon,
        color: iconColor,
        width: size,
        height: size,
      ),
      //   ),
    );
  }
}
