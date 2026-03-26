import 'dart:ui';

import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/appearance_ext/Appearance_screen.dart';
import 'package:TrackIt/features/Extras/data_ext/data_screen.dart';
import 'package:TrackIt/features/Extras/general_ext/General_screen.dart';
import 'package:TrackIt/features/Extras/privacy_ext/privacy_screen.dart';
import 'package:TrackIt/features/Extras/profile_ext/profile_screen.dart';
import 'package:TrackIt/features/Extras/settings_ext/Settings_screen.dart';
import 'package:TrackIt/features/Navbar/nav_bar.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:TrackIt/utils/format_currency.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../global_widgets/family_modal_sheet.dart';
import '../../global_widgets/text.ui.dart';

class ExtrasScreen extends StatefulWidget {
  const ExtrasScreen({super.key});

  @override
  State<ExtrasScreen> createState() => _ExtrasScreenState();
}

class _ExtrasScreenState extends State<ExtrasScreen> {
  List<Map<String, dynamic>> options = [
    {
      "Title": "Profile",
      "icon": profilepicPh,
      "subTitle": "Login, Authenticator..",
      "builder": (String title) => ProfileScreen(title: title),
    },
    {
      "Title": "Appearance",
      "icon": "assets/svg/appearanceSvg.svg",
      "subTitle": "Widget, themes",
      "builder": (String title) => AppearanceScreen(title: title),
    },
    {
      "Title": "General",
      "icon": "assets/svg/generalSvg.svg",
      "subTitle": "Currency, clear dara & more..",
      "builder": (String title) => GeneralScreen(title: title),
    },
    {
      "Title": "Settings",
      "icon": "assets/svg/settingsSvg.svg",
      "subTitle": "Account settings, Alerts & Notifications..",
      "builder": (String title) => SettingsScreen(title: title),
    },
    {
      "Title": "Data",
      "icon": "assets/svg/dataSvg.svg",
      "subTitle": "Data settings, export and import features",
      "builder": (String title) => DataScreen(title: title),
    },
    {
      "Title": "Privacy",
      "icon": "assets/svg/privacySvg.svg",
      "subTitle": "Password management, privacy preference..",
      "builder": (String title) => PrivacyScreen(title: title),
    },
  ];
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height, // Ensures proper height
          padding: EdgeInsets.all(24), // Adds spacing
          child: GridView.builder(
            physics: BouncingScrollPhysics(), // Enables smooth scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              crossAxisSpacing: 30, // Space between columns
              mainAxisSpacing: 20, // Space between rows
              mainAxisExtent: 200, // Each item height
            ),
            itemCount: options.length, // Number of items
            itemBuilder: (context, index) {
              final title = options[index]["Title"];
              String icon = options[index]["icon"];
              final subTitle = options[index]["subTitle"];
              final builder = options[index]["builder"];

              bool isSvg = icon.endsWith('svg');
              return GestureDetector(
                  onTap: () async {
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
                            border: Border.all(
                                color: Colors.white), // Soft white border
                          ),
                          child: ClipRRect(
                            // Clip the blur effect to match border radius
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY:
                                      10), // Increase blur for more glass effect
                              child: Container(
                                width: double.infinity,
                                // height: 200,
                                // margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.all(16),
                                // padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.onSurface
                                      .withOpacity(0.3), // Slight white overlay
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: builder != null && builder is Function
                                    ? builder(title)
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        );
                      },

                      // Optional configurations
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        )
                      ],
                      color: Theme.of(context).cardColor.withOpacity(
                          0.2), // Lower opacity for a frosted glass effect
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white
                              .withOpacity(0.2)), // Soft white border
                    ),
                    child: ClipRRect(
                      // Clip the blur effect to match border radius
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10), // Increase blur for more glass effect
                        child: Container(
                          width: double.infinity,
                          // height: 200,
                          // margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          // padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.outline
                                .withOpacity(0.1), // Slight white overlay
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: isSvg ? 30 : null,
                                  width: isSvg ? 30 : null,
                                  padding: EdgeInsets.all(isSvg ? 8 : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isSvg ? white : null,
                                  ),
                                  child: isSvg
                                      ? SvgPicture.asset(
                                          icon,
                                          color: grayScale900,
                                          // height: 20,
                                          // width: 20,
                                        )
                                      : Image.asset(icon)),

                              30.verticalSpace, // Space between icon & text
                              Text(
                                title ?? "Profile",
                                style: bodyNormBold,
                              ),
                              10.verticalSpace,
                              Text(
                                subTitle ?? 'Login, authentication',
                                style: bodyXSmall.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
