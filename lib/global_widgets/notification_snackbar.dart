// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:TrackIt/Resources/res.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

class ShowNotificationSnack {
  static showError(BuildContext context, String title, String content) {
    SmartSnackBars.showTemplatedSnackbar(
      duration: const Duration(seconds: 2),
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      context: context,
      backgroundColor: Colors.white,
      animateFrom: AnimateFrom.fromTop,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade50,
          // color: NearbyeColors.primaryShade100,
        ),
        child: SvgPicture.asset(
          color: white,
          helpIcon,
          width: 25,
        ),
      ),
      distanceToTravel: 10,
      titleWidget: Text(
        title,
        style: heading6,
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          content,
          style: bodySmall,
        ),
      ),
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    );
  }

  static showNotification(
      BuildContext context, String title, String content, String icon) {
    SmartSnackBars.showTemplatedSnackbar(
      duration: const Duration(seconds: 1),
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      context: context,
      backgroundColor: Colors.white,
      animateFrom: AnimateFrom.fromTop,
      leading: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: primary,
        ),
        child: SvgPicture.asset(
          color: white,
          icon ?? helpIcon,
          width: 25,
        ),
      ),
      distanceToTravel: 10,
      titleWidget: Text(
        title,
        style: heading6,
      ),
      subTitleWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          content,
          style: bodySmall,
        ),
      ),
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    );
  }
}
