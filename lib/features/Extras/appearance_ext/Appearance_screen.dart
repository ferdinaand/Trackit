import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/core/theme/theme_selector.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/Widgets/on_tap_scaler.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AppearanceScreen extends StatefulWidget {
  final String title;
  const AppearanceScreen({super.key, required this.title});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FamilyBottomSheetShell(headerText: widget.title, children: [
      ActionButton(
          icon: IconsaxPlusBold.color_swatch,
          color: colorScheme.primary,
          onTap: () async {
            await selectTheme(context, colorScheme);
          },
          title: "App Theme",
          subtitle: "Manage the look of your app"),
      ActionButton(
          icon: IconsaxPlusBold.menu,
          color: Colors.orange,
          title: "Widgets",
          subtitle: "Manage widgets on your home screen"),
    ]);
  }
}

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
        onTap: onTap,
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
