import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:TrackIt/config.dart';
import 'package:TrackIt/global_widgets/auth_back_button.ui.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TrackIt/Resources/res.dart';

class AuthAppbarUi extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppbarUi({
    super.key,
    this.actions,
  });

  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 64,
      leading: const AuthBackButtonUi(),
      actions: actions,
      centerTitle: true,
      title: Image.asset(
        flatLogo,
        height: 28.h,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MainAppbarUi extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbarUi({
    super.key,
    this.actions,
    required this.title,
    this.showBackButton = true,
    this.backgroundColor,
    this.iconColor,
    this.lead,
    this.iconBackgroundColor,
    this.titleColor,
    this.bottom,
    this.automaticallyImplyLeading = false,
    this.size,
  });

  final List<Widget>? actions;
  final Widget? lead;
  final String title;
  final double? size;
  final Color? titleColor;
  final bool showBackButton;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final PreferredSizeWidget? bottom;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      bottom: bottom,
      scrolledUnderElevation: 0,
      leadingWidth: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      leading: showBackButton
          ? GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.arrow_back,
                  size: size,
                ),
              ),
            )
          // AuthBackButtonUi(
          //     size: size,
          //     iconColor: iconColor,
          //     backgroundColor: iconBackgroundColor,
          //   )
          : lead,
      actions: actions,
      centerTitle: false,
      title: TextUi.bodyXLBold(
        style: headingBold5.copyWith(fontWeight: FontWeight.w500),
        title,
        color: titleColor ?? grayScale900,
      ),
    );
  }

  //get height of bottom widget
  double get heightOfBottomWidget {
    if (bottom == null) return 0;
    return bottom!.preferredSize.height;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + heightOfBottomWidget);
}
