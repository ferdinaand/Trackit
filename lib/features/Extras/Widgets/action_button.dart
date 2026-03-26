import 'dart:ui';

import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/Widgets/on_tap_scaler.dart';
import 'package:TrackIt/global_widgets/family_modal_sheet.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.padding,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 12),
      child: OnTapScaler(
        onTap: onTap ??
            () {
              comingSoon(context, colors);
            },
        child: Container(
          decoration: BoxDecoration(
            color: colors.onInverseSurface,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Icon
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  height: 42,
                  width: 42,
                  child: Icon(icon, size: 26, color: Colors.white),
                ),
              ),

              const SizedBox(width: 12),

              // --Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- Title
                    Text(
                      title,
                      style: bodyLBold,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    // const SizedBox(height: 2),

                    // -- Subtitle
                    Text(
                      subtitle,
                      style: bodyNorm.copyWith(
                        color: grayScale500,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

comingSoon(BuildContext context, ColorScheme colorScheme) async {
  await FamilyModalSheet.show<void>(
    mainContentBorderRadius: BorderRadius.circular(0),
    context: context,
    contentBackgroundColor: Colors.transparent,
    // Theme.of(context).colorScheme.surface,
    builder: (ctx) {
      return Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor.withOpacity(
          //     0.3), // Lower opacity for a frosted glass effect
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white), // Soft white border
        ),
        child: ClipRRect(
          // Clip the blur effect to match border radius
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10), // Increase blur for more glass effect
            child: Container(
              width: double.infinity,
              // height: 200,
              // margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              // padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer
                    .withOpacity(0.3), // Slight white overlay
                borderRadius: BorderRadius.circular(20),
              ),
              child: FamilyBottomSheetShell(
                  headerText: 'Coming soon', children: []),
            ),
          ),
        ),
      );
    },

    //Optional configurations
  );
}
