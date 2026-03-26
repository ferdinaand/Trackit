import 'dart:ui';

import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/general_ext/General_screen.dart';
import 'package:TrackIt/global_widgets/family_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'theme_scheme.dart';

// class ThemeSelector extends StatelessWidget {
//   const ThemeSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return ActionButton(
//       icon: ,
//       color: Colors.grey,
//       title: 'Select theme',
//       subtitle: '',
selectTheme(BuildContext context, ColorScheme colorScheme) async {
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
              child: SizedBox(
                width: 200,
                height: 700,
                child: GridView.builder(
                  // shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of columns in grid
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1, // Ensures square grid items
                  ),
                  itemCount: ThemeScheme.values.length,
                  itemBuilder: (context, index) {
                    final scheme = ThemeScheme.values[index];
                    final isSelected =
                        scheme == context.read<ThemeProvider>().currentScheme;

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close the popup
                        context.read<ThemeProvider>().setTheme(scheme);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: scheme.seedColor,
                              // borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   scheme.displayName,
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     fontWeight: isSelected
                          //         ? FontWeight.bold
                          //         : FontWeight.normal,
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },

    //Optional configurations
  );
  // },
  // );

  // PopupMenuButton<ThemeScheme>(
  //   icon: const Icon(Icons.palette),
  //   tooltip: 'Select theme',
  //   onSelected: (ThemeScheme scheme) {
  //     context.read<ThemeProvider>().setTheme(scheme);
  //   },
  //   itemBuilder: (BuildContext context) {
  //     final customScrollThemeWidget =
  //         List.generate(ThemeScheme.values.length, (index) {
  //       final scheme = ThemeScheme.values[index];
  //       final isSelected =
  //           scheme == context.read<ThemeProvider>().currentScheme;
  //       return Container(
  //         width: 150,
  //         height: 50,
  //         decoration: BoxDecoration(
  //           color: scheme.seedColor,
  //           borderRadius: BorderRadius.circular(10),
  //           // shape: BoxShape.rectangle,
  //           border: isSelected
  //               ? Border.all(
  //                   color: Theme.of(context).unselectedWidgetColor,
  //                   width: 2,
  //                 )
  //               : null,
  //         ),
  //         child: isSelected
  //             ? const Icon(Icons.check, color: Colors.white)
  //             : null,
  //       );
  //     });

  //     return [
  //       PopupMenuItem(
  //         enabled: false, // Disables the default menu item behavior
  //         child: SizedBox(
  //           width: 500,
  //           height: MediaQuery.of(context).size.height,
  //           child: GridView.builder(
  //             shrinkWrap: true,
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3, // Number of columns in grid
  //               crossAxisSpacing: 8,
  //               mainAxisSpacing: 8,
  //               childAspectRatio: 1, // Ensures square grid items
  //             ),
  //             itemCount: ThemeScheme.values.length,
  //             itemBuilder: (context, index) {
  //               final scheme = ThemeScheme.values[index];
  //               final isSelected =
  //                   scheme == context.read<ThemeProvider>().currentScheme;

  //               return GestureDetector(
  //                 onTap: () {
  //                   Navigator.pop(context); // Close the popup
  //                   context.read<ThemeProvider>().setTheme(scheme);
  //                 },
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       height: 50,
  //                       width: 50,
  //                       decoration: BoxDecoration(
  //                         color: scheme.seedColor,
  //                         // borderRadius: BorderRadius.circular(10),
  //                         shape: BoxShape.circle,
  //                         border: isSelected
  //                             ? Border.all(
  //                                 color:
  //                                     Theme.of(context).unselectedWidgetColor,
  //                                 width: 2,
  //                               )
  //                             : null,
  //                       ),
  //                       child: isSelected
  //                           ? const Icon(Icons.check, color: Colors.white)
  //                           : null,
  //                     ),
  //                     const SizedBox(height: 4),
  //                     // Text(
  //                     //   scheme.displayName,
  //                     //   style: TextStyle(
  //                     //     fontSize: 12,
  //                     //     fontWeight: isSelected
  //                     //         ? FontWeight.bold
  //                     //         : FontWeight.normal,
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ];
  //   },
  // );
}
// }
//
